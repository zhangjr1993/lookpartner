import 'package:shared_preferences/shared_preferences.dart';
import 'current_user_service.dart';

class SignupLimitService {
  static const String _dailySignupKey = 'daily_signup_count_v2';
  static const String _lastSignupDateKey = 'last_signup_date_v2';
  static const int _maxDailySignups = 3; // 非VIP用户每天最多报名3个活动
  
  // 检查是否可以报名
  static Future<bool> canSignUp() async {
    // VIP用户无限制
    final isVipValid = await CurrentUserService.isVipValid();
    if (isVipValid) {
      return true;
    }
    
    // 非VIP用户检查每日限制
    return await _checkDailyLimit();
  }
  
  // 检查每日报名限制
  static Future<bool> _checkDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final lastSignupDate = prefs.getString(_lastSignupDateKey);
    final currentCount = prefs.getInt(_dailySignupKey) ?? 0;
    
    // 如果是新的一天，重置计数
    if (lastSignupDate != todayString) {
      await prefs.setString(_lastSignupDateKey, todayString);
      await prefs.setInt(_dailySignupKey, 0);
      return true;
    }
    
    // 检查是否超过每日限制
    return currentCount < _maxDailySignups;
  }
  
  // 增加报名次数
  static Future<void> incrementSignupCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_dailySignupKey) ?? 0;
    await prefs.setInt(_dailySignupKey, currentCount + 1);
  }
  
  // 获取今日剩余报名次数
  static Future<int> getRemainingSignups() async {
    // VIP用户无限制
    final isVipValid = await CurrentUserService.isVipValid();
    if (isVipValid) {
      return -1; // -1表示无限制
    }
    
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final lastSignupDate = prefs.getString(_lastSignupDateKey);
    final currentCount = prefs.getInt(_dailySignupKey) ?? 0;
    
    // 如果是新的一天，重置计数
    if (lastSignupDate != todayString) {
      return _maxDailySignups;
    }
    
    return _maxDailySignups - currentCount;
  }
  
  // 获取今日已报名次数
  static Future<int> getTodaySignupCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final lastSignupDate = prefs.getString(_lastSignupDateKey);
    final currentCount = prefs.getInt(_dailySignupKey) ?? 0;
    
    // 如果是新的一天，返回0
    if (lastSignupDate != todayString) {
      return 0;
    }
    
    return currentCount;
  }
  
  // 重置报名计数（用于测试）
  static Future<void> resetSignupCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailySignupKey);
    await prefs.remove(_lastSignupDateKey);
  }
}
