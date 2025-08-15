import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class KeychainService {
  static const String _userKey = 'user_info_v4';

  /// 保存用户信息到本地存储
  static Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      throw Exception('保存用户信息失败: $e');
    }
  }

  /// 从本地存储读取用户信息
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      // 如果读取失败，返回null表示没有用户信息
      return null;
    }
  }

  /// 从本地存储删除用户信息
  static Future<void> deleteUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      throw Exception('删除用户信息失败: $e');
    }
  }

  /// 检查是否有用户信息
  static Future<bool> hasUser() async {
    final user = await getUser();
    return user != null;
  }

  /// 更新用户信息
  static Future<void> updateUser(User user) async {
    await saveUser(user);
  }
}
