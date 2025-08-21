import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class KeychainService {
  static const String _userKey = 'user_info_v4';
  static const MethodChannel _channel = MethodChannel('com.lookpartner.keychain');

  /// 保存用户信息到本地存储
  static Future<void> saveUser(User user) async {
    try {
      if (Platform.isIOS) {
        // iOS使用keychain channel
        print('🔐 使用iOS keychain channel保存用户信息');
        final userJson = user.toJson();
        print('📱 用户数据: $userJson');
        final result = await _channel.invokeMethod('saveUser', userJson);
        print('✅ iOS keychain保存结果: $result');
        if (result != true) {
          throw Exception('iOS keychain保存失败');
        }
      } else {
        // Android和其他平台使用shared_preferences
        print('🤖 使用Android shared_preferences保存用户信息');
        final prefs = await SharedPreferences.getInstance();
        final userJson = jsonEncode(user.toJson());
        await prefs.setString(_userKey, userJson);
      }
    } catch (e) {
      print('❌ 保存用户信息失败: $e');
      throw Exception('保存用户信息失败: $e');
    }
  }

  /// 从本地存储读取用户信息
  static Future<User?> getUser() async {
    try {
      if (Platform.isIOS) {
        // iOS使用keychain channel
        final result = await _channel.invokeMethod('getUser');
        if (result != null) {
          final userMap = result as Map<String, dynamic>;
          return User.fromJson(userMap);
        }
        return null;
      } else {
        // Android和其他平台使用shared_preferences
        final prefs = await SharedPreferences.getInstance();
        final userJson = prefs.getString(_userKey);
        
        if (userJson != null) {
          final userMap = jsonDecode(userJson) as Map<String, dynamic>;
          return User.fromJson(userMap);
        }
        return null;
      }
    } catch (e) {
      // 如果读取失败，返回null表示没有用户信息
      return null;
    }
  }

  /// 从本地存储删除用户信息
  static Future<void> deleteUser() async {
    try {
      if (Platform.isIOS) {
        // iOS使用keychain channel
        final result = await _channel.invokeMethod('deleteUser');
        if (result != true) {
          throw Exception('iOS keychain删除失败');
        }
      } else {
        // Android和其他平台使用shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_userKey);
      }
    } catch (e) {
      throw Exception('删除用户信息失败: $e');
    }
  }

  /// 检查是否有用户信息
  static Future<bool> hasUser() async {
    try {
      if (Platform.isIOS) {
        // iOS使用keychain channel
        final result = await _channel.invokeMethod('hasUser');
        return result == true;
      } else {
        // Android和其他平台使用shared_preferences
        final user = await getUser();
        return user != null;
      }
    } catch (e) {
      return false;
    }
  }

  /// 更新用户信息
  static Future<void> updateUser(User user) async {
    await saveUser(user);
  }
}
