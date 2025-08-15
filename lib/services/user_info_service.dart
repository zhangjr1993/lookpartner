import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserInfoService {
  static const String _userInfoKey = 'user_info_v2';
  
  // 用户信息模型
  static const String _defaultUserName = '寒寒';
  static const int _defaultAge = 24;
  static const String _defaultAvatar = '';
  static const String _defaultLocation = '火星';
  
  // 获取用户信息
  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString(_userInfoKey);
    
    if (userInfoJson != null) {
      try {
        return jsonDecode(userInfoJson);
      } catch (e) {
        print('解析用户信息失败: $e');
      }
    }
    
    // 返回默认用户信息
    return {
      'userName': _defaultUserName,
      'age': _defaultAge,
      'avatar': _defaultAvatar,
      'location': _defaultLocation,
      'avatarStatus': 'normal', // normal, pending (审核中)
    };
  }
  
  // 保存用户信息
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = jsonEncode(userInfo);
    await prefs.setString(_userInfoKey, userInfoJson);
  }
  
  // 更新用户姓名
  static Future<void> updateUserName(String userName) async {
    final userInfo = await getUserInfo();
    userInfo['userName'] = userName;
    await saveUserInfo(userInfo);
  }
  
  // 更新用户年龄
  static Future<void> updateUserAge(int age) async {
    final userInfo = await getUserInfo();
    userInfo['age'] = age;
    await saveUserInfo(userInfo);
  }
  
  // 更新用户头像
  static Future<void> updateUserAvatar(String avatar, {bool isNewUpload = false}) async {
    final userInfo = await getUserInfo();
    userInfo['avatar'] = avatar;
    
    // 如果是新上传的头像，设置为审核中状态
    if (isNewUpload) {
      userInfo['avatarStatus'] = 'pending';
    }
    
    await saveUserInfo(userInfo);
  }
  
  // 更新头像审核状态
  static Future<void> updateAvatarStatus(String status) async {
    final userInfo = await getUserInfo();
    userInfo['avatarStatus'] = status; // 'normal' 或 'pending'
    await saveUserInfo(userInfo);
  }
  
  // 获取用户姓名
  static Future<String> getUserName() async {
    final userInfo = await getUserInfo();
    return userInfo['userName'] ?? _defaultUserName;
  }
  
  // 获取用户年龄
  static Future<int> getUserAge() async {
    final userInfo = await getUserInfo();
    return userInfo['age'] ?? _defaultAge;
  }
  
  // 获取用户头像
  static Future<String> getUserAvatar() async {
    final userInfo = await getUserInfo();
    return userInfo['avatar'] ?? _defaultAvatar;
  }
  
  // 获取用户位置
  static Future<String> getUserLocation() async {
    final userInfo = await getUserInfo();
    return userInfo['location'] ?? _defaultLocation;
  }
  
  // 获取头像审核状态
  static Future<String> getAvatarStatus() async {
    final userInfo = await getUserInfo();
    return userInfo['avatarStatus'] ?? 'normal';
  }
  
  // 获取格式化的用户信息字符串
  static Future<String> getFormattedUserInfo() async {
    final age = await getUserAge();
    final location = await getUserLocation();
    return '$age岁 / $location';
  }
  
  // 重置用户信息（用于测试）
  static Future<void> resetUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userInfoKey);
  }
}
