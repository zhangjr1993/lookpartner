import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/blacklist_service.dart';
import '../services/chat_service.dart';
import '../services/user_service.dart';
import 'chat_detail_page.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  List<ChatModel> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // 从聊天缓存获取所有聊天用户
      final userIds = await ChatService.getAllChatUsers();
      
      if (userIds.isEmpty) {
        setState(() {
          _chats = [];
          _isLoading = false;
        });
        return;
      }
      
      // 批量获取用户信息
      final usersInfo = await UserService.getUsersInfo(userIds);
      
      // 为每个用户创建聊天模型
      final allChats = <ChatModel>[];
      
      for (final userId in userIds) {
        try {
          // 加载该用户的聊天记录
          final messages = await ChatService.loadChatMessages(userId);
          
          if (messages.isNotEmpty) {
            // 获取最后一条消息
            final lastMessage = messages.last;
            
            // 获取用户信息
            final userInfo = usersInfo[userId];
            
            // 创建聊天模型
            final chat = ChatModel(
              userId: userId,
              userNickname: userInfo?.nickname ?? '用户$userId',
              userAvatar: userInfo?.avatar != null && userInfo!.avatar.isNotEmpty 
                  ? 'assets/images/discoverAssets/${userInfo.avatar}'
                  : 'assets/images/discoverAssets/avatar_1.webp',
              lastMessage: lastMessage.content,
              lastMessageTime: lastMessage.timestamp,
            );
            
            allChats.add(chat);
          }
        } catch (e) {
          print('加载用户 $userId 的聊天记录失败: $e');
        }
      }
      
      // 按最后消息时间排序
      allChats.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      
      // 过滤黑名单用户
      final filteredChats = await BlacklistService.filterBlacklistedUsers(
        allChats,
        (chat) => chat.userId,
      );
      
      setState(() {
        _chats = filteredChats;
        _isLoading = false;
      });
    } catch (e) {
      print('加载聊天列表失败: $e');
      setState(() {
        _chats = [];
        _isLoading = false;
      });
    }
  }

  String _formatTime(DateTime time) {
    return '${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 背景图片
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/msgAssets/bg_message.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 渐变遮罩层
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.1),
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          
          // 内容区域
          Column(
            children: [
              // 自定义导航栏
              Container(
                height: 44, // iOS标准导航栏高度
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // 返回按钮
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // 标题
                    const Text(
                      '我的消息',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // 占位，保持标题居中
                    const SizedBox(width: 32),
                  ],
                ),
              ),
              
              // 聊天列表
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _chats.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '还没有共同爱好的朋友哦~',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _chats.length,
                            itemBuilder: (context, index) {
                              return _buildChatItem(_chats[index]);
                            },
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(ChatModel chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(
                userId: chat.userId,
                userNickname: chat.userNickname,
                userAvatar: chat.userAvatar,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
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
                backgroundImage: chat.userAvatar.isNotEmpty
                    ? AssetImage(chat.userAvatar)
                    : null,
                child: chat.userAvatar.isEmpty
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 用户昵称和时间
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.userNickname,
                            style: const TextStyle(
                              color: Color(0xFF171717),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // 时间
                        Text(
                          _formatTime(chat.lastMessageTime),
                          style: const TextStyle(
                            color: Color(0xFF9598AC),
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 最近聊天记录
                    Text(
                      chat.lastMessage,
                      style: const TextStyle(
                        color: Color(0xFF9598AC),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 聊天模型
class ChatModel {
  final String userId;
  final String userNickname;
  final String userAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.userId,
    required this.userNickname,
    required this.userAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
