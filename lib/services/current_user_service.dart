import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class CurrentUserService {
  static const String _currentUserKey = 'current_user_v2';
  static const String _isVipKey = 'is_vip_v2';
  static const String _vipExpireTimeKey = 'vip_expire_time_v2';
  
  // 获取当前用户ID
  static Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }
  
  // 设置当前用户ID
  static Future<void> setCurrentUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, userId);
  }
  
  // 获取当前用户VIP状态
  static Future<bool> isCurrentUserVip() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isVipKey) ?? false;
  }
  
  // 设置当前用户VIP状态
  static Future<void> setCurrentUserVip(bool isVip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isVipKey, isVip);
  }
  
  // 获取VIP过期时间
  static Future<DateTime?> getVipExpireTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_vipExpireTimeKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
  
  // 设置VIP过期时间
  static Future<void> setVipExpireTime(DateTime? expireTime) async {
    final prefs = await SharedPreferences.getInstance();
    if (expireTime != null) {
      await prefs.setInt(_vipExpireTimeKey, expireTime.millisecondsSinceEpoch);
    } else {
      await prefs.remove(_vipExpireTimeKey);
    }
  }
  
  // 检查VIP是否有效（未过期）
  static Future<bool> isVipValid() async {
    final isVip = await isCurrentUserVip();
    if (!isVip) return false;
    
    final expireTime = await getVipExpireTime();
    if (expireTime == null) return false;
    
    return DateTime.now().isBefore(expireTime);
  }
  
  // 清除当前用户信息
  static Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.remove(_isVipKey);
    await prefs.remove(_vipExpireTimeKey);
  }
  
  // 设置当前用户信息
  static Future<void> setCurrentUser(User user) async {
    await setCurrentUserId(user.userId);
    await setCurrentUserVip(user.isVip);
    await setVipExpireTime(user.vipExpireTime);
  }
}
