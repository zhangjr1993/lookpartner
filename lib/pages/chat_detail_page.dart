import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/chat_service.dart';
import '../services/blacklist_service.dart';
import '../services/report_service.dart';
import '../services/diamond_service.dart';
import '../services/current_user_service.dart';
import '../services/user_service.dart';
import 'vip_membership_page.dart';

class ChatDetailPage extends StatefulWidget {
  final String userId;
  final String userNickname;
  final String userAvatar;
  final String? userGender;
  final String? userPersonalityTag;

  const ChatDetailPage({
    super.key,
    required this.userId,
    required this.userNickname,
    required this.userAvatar,
    this.userGender,
    this.userPersonalityTag,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = true;
  
  // 用户信息
  UserInfo? _userInfo;

  @override
  void initState() {
    super.initState();
    
    // 调试打印接收到的头像信息
    print('ChatDetailPage: 接收到的头像信息:');
    print('  - userAvatar: ${widget.userAvatar}');
    print('  - userNickname: ${widget.userNickname}');
    print('  - userId: ${widget.userId}');
    
    _loadUserInfo();
    _loadMessages();
  }
  
  // 加载用户信息
  Future<void> _loadUserInfo() async {
    try {
      // 首先尝试从缓存获取用户信息
      UserInfo? userInfo = await UserService.getUserInfo(widget.userId);
      
      // 如果缓存中没有，使用传递过来的信息创建用户信息
      if (userInfo == null) {
        userInfo = UserInfo(
          userId: widget.userId,
          nickname: widget.userNickname,
          avatar: widget.userAvatar,
          gender: widget.userGender ?? '女',
          personalityTag: widget.userPersonalityTag ?? 'ENFP',
          age: 24,
        );
        
        // 保存到缓存
        await UserService.saveUserInfo(userInfo);
        print('ChatDetailPage: 创建并保存新用户信息');
      }
      
      setState(() {
        _userInfo = userInfo;
      });
      
      print('ChatDetailPage: 加载到用户信息:');
      print('  - nickname: ${userInfo.nickname}');
      print('  - gender: ${userInfo.gender}');
      print('  - personalityTag: ${userInfo.personalityTag}');
    } catch (e) {
      print('ChatDetailPage: 加载用户信息失败: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // 从本地缓存加载聊天记录
      final messages = await ChatService.loadChatMessages(widget.userId);
      
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
        _isLoading = false;
      });
    } catch (e) {
      print('加载聊天记录失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    // 检查是否可以发送消息
    final canSend = await DiamondService.canSendMessage();
    if (!canSend) {
      // 检查是否为VIP用户
      final isVipValid = await CurrentUserService.isVipValid();
      if (isVipValid) {
        _showToast("发送失败，请重试");
      } else {
        // 非VIP用户，跳转到会员页面
        _showToast("钻石不足，请先充值");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VipMembershipPage()),
        );
      }
      return;
    }

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _messageController.text.trim(),
      isFromMe: true,
      timestamp: DateTime.now(),
    );

    // 扣除钻石
    final success = await DiamondService.sendMessage();
    if (!success) {
      _showToast("发送失败，请重试");
      return;
    }

    setState(() {
      _messages.add(message);
    });

    // 保存消息到本地缓存
    await ChatService.addMessage(
      widget.userId, 
      message,
      userNickname: widget.userNickname,
      userAvatar: widget.userAvatar,
    );

    _messageController.clear();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.userNickname,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primaryText),
            onPressed: () {
              _showMoreOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 用户信息卡
          _buildUserInfoCard(),
          
          // 聊天记录区域
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '开始聊天吧~',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageItem(_messages[index]);
                        },
                      ),
          ),
          
          // 输入框区域
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: '讨论一下活动细节吧~',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryTextHighlight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: AppColors.primaryText,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 用户头像
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: AssetImage(widget.userAvatar),
            child: widget.userAvatar.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  )
                : null,
          ),
          
          const SizedBox(width: 12),
          
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 昵称和个性标签
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _userInfo?.nickname ?? widget.userNickname,
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF538),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _userInfo?.personalityTag ?? 'ENFP',
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // 性别、年龄、地区
                Text(
                  '${_userInfo?.gender ?? '女'} / ${_userInfo?.age ?? 24}岁 / 火星',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: message.isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: message.isFromMe 
                        ? const Color(0xFFFFF538)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(
                      color: Color(0xFF171717),
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('加入黑名单', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _addToBlacklist();
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.orange),
              title: const Text('举报用户', style: TextStyle(color: Colors.orange)),
              onTap: () {
                Navigator.pop(context);
                _reportUser();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addToBlacklist() async {
    final success = await BlacklistService.addToBlacklist(widget.userId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已加入黑名单')),
      );
      Navigator.pop(context); // 关闭聊天页面
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('操作失败，请重试')),
      );
    }
  }

  void _reportUser() {
    _showReportDialog();
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => _ReportDialog(
        onSubmit: _submitReport,
      ),
    );
  }

  void _submitReport(String reason) async {
    final report = ReportRecord(
      id: 'report_${DateTime.now().millisecondsSinceEpoch}',
      targetUserId: widget.userId,
      targetName: widget.userNickname,
      reportType: reason,
      content: '举报用户: ${widget.userNickname}，原因: $reason',
      reportTime: DateTime.now(),
      status: ReportStatus.pending,
    );
    
    final success = await ReportService.saveReport(report);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('举报成功：$reason')),
      );
      Navigator.pop(context); // 关闭对话框
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('举报失败，请重试')),
      );
    }
  }
}



class _ReportDialog extends StatefulWidget {
  final Function(String) onSubmit;

  const _ReportDialog({required this.onSubmit});

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  String selectedReason = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('举报用户'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('请选择举报原因：'),
          const SizedBox(height: 16),
          ...['骚扰行为', '不当言论', '虚假信息', '其他'].map((reason) => 
            RadioListTile<String>(
              value: reason,
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() {
                  selectedReason = value!;
                });
              },
              title: Text(reason),
              activeColor: AppColors.primaryTextHighlight,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: selectedReason.isEmpty ? null : () {
            Navigator.pop(context);
            widget.onSubmit(selectedReason);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTextHighlight,
            foregroundColor: AppColors.primaryText,
          ),
          child: const Text('提交举报'),
        ),
      ],
    );
  }
}
