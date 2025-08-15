import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'user_service.dart';

class ChatMessage {
  final String id;
  final String content;
  final bool isFromMe;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromMe,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isFromMe': isFromMe,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isFromMe: json['isFromMe'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}

class ChatService {
  static const String _chatCacheDir = 'chat_cache';
  
  // 随机问候消息
  static const List<String> _greetingMessages = [
    "嘿，你好呀",
    "有什么想知道的尽管问，哈哈",
    "你介意AA吗",
    "很高兴认识你"
  ];

  // 获取聊天缓存文件路径
  static Future<String> _getChatFilePath(String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final chatDir = Directory('${directory.path}/$_chatCacheDir');
    
    // 确保聊天缓存目录存在
    if (!await chatDir.exists()) {
      await chatDir.create(recursive: true);
    }
    
    return '${chatDir.path}/chat_$userId.json';
  }

  // 检查是否是第一次和对方聊天
  static Future<bool> isFirstTimeChat(String userId) async {
    try {
      final filePath = await _getChatFilePath(userId);
      final file = File(filePath);
      return !await file.exists();
    } catch (e) {
      print('检查首次聊天失败: $e');
      return true;
    }
  }

  // 加载聊天记录
  static Future<List<ChatMessage>> loadChatMessages(String userId) async {
    try {
      final filePath = await _getChatFilePath(userId);
      final file = File(filePath);
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        // 第一次聊天，创建随机问候消息
        final greetingMessage = ChatMessage(
          id: 'greeting_${DateTime.now().millisecondsSinceEpoch}',
          content: _getRandomGreeting(),
          isFromMe: false,
          timestamp: DateTime.now(),
        );
        
        // 保存问候消息
        await saveChatMessages(userId, [greetingMessage]);
        return [greetingMessage];
      }
    } catch (e) {
      print('加载聊天记录失败: $e');
      return [];
    }
  }

  // 保存聊天记录
  static Future<void> saveChatMessages(String userId, List<ChatMessage> messages) async {
    try {
      final filePath = await _getChatFilePath(userId);
      final file = File(filePath);
      
      final jsonList = messages.map((message) => message.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      await file.writeAsString(jsonString);
      print('聊天记录保存成功: $userId');
    } catch (e) {
      print('保存聊天记录失败: $e');
    }
  }

  // 添加新消息
  static Future<void> addMessage(String userId, ChatMessage message, {String? userNickname, String? userAvatar}) async {
    try {
      final existingMessages = await loadChatMessages(userId);
      existingMessages.add(message);
      await saveChatMessages(userId, existingMessages);
      
      // 如果提供了用户信息，同时保存用户信息
      if (userNickname != null || userAvatar != null) {
        final existingUserInfo = await UserService.getUserInfo(userId);
        final updatedUserInfo = UserInfo(
          userId: userId,
          nickname: userNickname ?? existingUserInfo?.nickname ?? '用户$userId',
          avatar: userAvatar ?? existingUserInfo?.avatar ?? 'activity_sg_1001.webp',
          gender: existingUserInfo?.gender ?? '女',
          personalityTag: existingUserInfo?.personalityTag ?? 'ENFP',
          age: existingUserInfo?.age ?? 24,
        );
        await UserService.saveUserInfo(updatedUserInfo);
      }
    } catch (e) {
      print('添加消息失败: $e');
    }
  }

  // 获取随机问候消息
  static String _getRandomGreeting() {
    final random = Random();
    return _greetingMessages[random.nextInt(_greetingMessages.length)];
  }

  // 清理聊天记录
  static Future<void> clearChatHistory(String userId) async {
    try {
      final filePath = await _getChatFilePath(userId);
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
        print('聊天记录已清除: $userId');
      }
    } catch (e) {
      print('清除聊天记录失败: $e');
    }
  }

  // 获取所有聊天用户列表
  static Future<List<String>> getAllChatUsers() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final chatDir = Directory('${directory.path}/$_chatCacheDir');
      
      if (!await chatDir.exists()) {
        return [];
      }
      
      final files = await chatDir.list().toList();
      final userIds = <String>[];
      
      for (final file in files) {
        if (file is File && file.path.endsWith('.json')) {
          final fileName = file.path.split('/').last;
          if (fileName.startsWith('chat_') && fileName.endsWith('.json')) {
            final userId = fileName.substring(5, fileName.length - 5); // 移除 'chat_' 前缀和 '.json' 后缀
            userIds.add(userId);
          }
        }
      }
      
      return userIds;
    } catch (e) {
      print('获取聊天用户列表失败: $e');
      return [];
    }
  }
}
