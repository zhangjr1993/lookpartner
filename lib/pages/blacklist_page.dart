import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/blacklist_service.dart';

class BlacklistPage extends StatefulWidget {
  const BlacklistPage({super.key});

  @override
  State<BlacklistPage> createState() => _BlacklistPageState();
}

class _BlacklistPageState extends State<BlacklistPage> {
  List<BlacklistedUser> _blacklistedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBlacklistedUsers();
  }

  Future<void> _loadBlacklistedUsers() async {
    try {
      final blacklist = await BlacklistService.getBlacklist();
      
      // 模拟用户数据（实际应该从用户服务获取）
      final users = blacklist.map((userId) => BlacklistedUser(
        id: userId,
        nickname: '用户$userId',
        avatar: 'avatar.jpg',
        reason: '用户举报',
        blockedTime: DateTime.now().subtract(const Duration(days: 1)),
      )).toList();
      
      setState(() {
        _blacklistedUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromBlacklist(String userId) async {
    try {
      final success = await BlacklistService.removeFromBlacklist(userId);
      if (success) {
        setState(() {
          _blacklistedUsers.removeWhere((user) => user.id == userId);
        });
        _showToast('已从黑名单移除');
      } else {
        _showToast('移除失败，请重试');
      }
    } catch (e) {
      _showToast('操作失败，请重试');
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '黑名单',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _blacklistedUsers.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.block,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '没有拉黑的用户',
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
                  itemCount: _blacklistedUsers.length,
                  itemBuilder: (context, index) {
                    return _buildBlacklistedUserItem(_blacklistedUsers[index]);
                  },
                ),
    );
  }

  Widget _buildBlacklistedUserItem(BlacklistedUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // 用户头像
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(
              Icons.person,
              size: 30,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nickname,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '拉黑原因: ${user.reason}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '拉黑时间: ${_formatTime(user.blockedTime)}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // 移除按钮
          IconButton(
            onPressed: () => _removeFromBlacklist(user.id),
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
              size: 24,
            ),
            tooltip: '从黑名单移除',
          ),
        ],
      ),
    );
  }
}

class BlacklistedUser {
  final String id;
  final String nickname;
  final String avatar;
  final String reason;
  final DateTime blockedTime;

  BlacklistedUser({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.reason,
    required this.blockedTime,
  });
}
