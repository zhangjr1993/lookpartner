import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BlacklistService {
  static const String _blacklistKey = 'blacklist_users_v2';
  
  // 添加用户到黑名单
  static Future<bool> addToBlacklist(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final blacklist = await getBlacklist();
      blacklist.add(userId);
      
      await prefs.setString(_blacklistKey, jsonEncode(blacklist));
      return true;
    } catch (e) {
      print('添加黑名单失败: $e');
      return false;
    }
  }
  
  // 从黑名单移除用户
  static Future<bool> removeFromBlacklist(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final blacklist = await getBlacklist();
      blacklist.remove(userId);
      
      await prefs.setString(_blacklistKey, jsonEncode(blacklist));
      return true;
    } catch (e) {
      print('移除黑名单失败: $e');
      return false;
    }
  }
  
  // 获取黑名单列表
  static Future<List<String>> getBlacklist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final blacklistJson = prefs.getString(_blacklistKey);
      
      if (blacklistJson != null) {
        final List<dynamic> blacklist = jsonDecode(blacklistJson);
        return blacklist.cast<String>();
      }
      
      return [];
    } catch (e) {
      print('获取黑名单失败: $e');
      return [];
    }
  }
  
  // 检查用户是否在黑名单中
  static Future<bool> isUserBlacklisted(String userId) async {
    final blacklist = await getBlacklist();
    return blacklist.contains(userId);
  }
  
  // 过滤黑名单用户
  static Future<List<T>> filterBlacklistedUsers<T>(List<T> users, String Function(T) getUserId) async {
    final blacklist = await getBlacklist();
    return users.where((user) => !blacklist.contains(getUserId(user))).toList();
  }
}

