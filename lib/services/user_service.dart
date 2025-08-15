import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserInfo {
  final String userId;
  final String nickname;
  final String avatar;
  final String gender;
  final String personalityTag;
  final int age;

  UserInfo({
    required this.userId,
    required this.nickname,
    required this.avatar,
    required this.gender,
    required this.personalityTag,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'avatar': avatar,
      'gender': gender,
      'personalityTag': personalityTag,
      'age': age,
    };
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] ?? '',
      nickname: json['nickname'] ?? '',
      avatar: json['avatar'] ?? '',
      gender: json['gender'] ?? '',
      personalityTag: json['personalityTag'] ?? '',
      age: json['age'] ?? 24,
    );
  }
}

class UserService {
  static const String _userCacheDir = 'user_cache';
  
  // 获取用户缓存文件路径
  static Future<String> _getUserCachePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final userDir = Directory('${directory.path}/$_userCacheDir');
    
    // 确保用户缓存目录存在
    if (!await userDir.exists()) {
      await userDir.create(recursive: true);
    }
    
    return '${userDir.path}/users.json';
  }

  // 保存用户信息
  static Future<void> saveUserInfo(UserInfo userInfo) async {
    try {
      final filePath = await _getUserCachePath();
      final file = File(filePath);
      
      Map<String, UserInfo> users = {};
      
      // 读取现有用户数据
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        users = jsonData.map((key, value) => MapEntry(key, UserInfo.fromJson(value)));
      }
      
      // 添加或更新用户信息
      users[userInfo.userId] = userInfo;
      
      // 保存到文件
      final jsonString = jsonEncode(users.map((key, value) => MapEntry(key, value.toJson())));
      await file.writeAsString(jsonString);
      
      print('用户信息保存成功: ${userInfo.userId}');
    } catch (e) {
      print('保存用户信息失败: $e');
    }
  }

  // 获取用户信息
  static Future<UserInfo?> getUserInfo(String userId) async {
    try {
      final filePath = await _getUserCachePath();
      final file = File(filePath);
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        final users = jsonData.map((key, value) => MapEntry(key, UserInfo.fromJson(value)));
        
        return users[userId];
      }
    } catch (e) {
      print('获取用户信息失败: $e');
    }
    
    return null;
  }

  // 批量获取用户信息
  static Future<Map<String, UserInfo>> getUsersInfo(List<String> userIds) async {
    try {
      final filePath = await _getUserCachePath();
      final file = File(filePath);
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        final allUsers = jsonData.map((key, value) => MapEntry(key, UserInfo.fromJson(value)));
        
        // 只返回请求的用户信息
        return Map.fromEntries(
          userIds.map((userId) => MapEntry(userId, allUsers[userId] ?? _createDefaultUserInfo(userId)))
        );
      }
    } catch (e) {
      print('批量获取用户信息失败: $e');
    }
    
    // 如果没有缓存或出错，返回默认用户信息
    return Map.fromEntries(
      userIds.map((userId) => MapEntry(userId, _createDefaultUserInfo(userId)))
    );
  }

  // 创建默认用户信息
  static UserInfo _createDefaultUserInfo(String userId) {
    return UserInfo(
      userId: userId,
      nickname: '用户$userId',
      avatar: 'activity_sg_1001.webp',
      gender: '女',
      personalityTag: 'ENFP',
      age: 24,
    );
  }

  // 清除用户缓存
  static Future<void> clearUserCache() async {
    try {
      final filePath = await _getUserCachePath();
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
        print('用户缓存已清除');
      }
    } catch (e) {
      print('清除用户缓存失败: $e');
    }
  }
}
