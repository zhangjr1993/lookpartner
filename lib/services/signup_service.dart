import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'signup_limit_service.dart';

class SignupService {
  static const String _signupKey = 'user_signups_v2';
  static const String _dailyCountKey = 'daily_signup_count_v2';
  static const String _lastSignupDateKey = 'last_signup_date_v2';

  // 获取已报名的活动ID列表
  static Future<List<String>> getSignedUpActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final signupsJson = prefs.getString(_signupKey);
      if (signupsJson != null) {
        final List<dynamic> signupsList = jsonDecode(signupsJson);
        return signupsList.cast<String>();
      }
      return [];
    } catch (e) {
      print('获取报名列表错误: $e');
      return [];
    }
  }

  // 检查是否已报名某个活动
  static Future<bool> isActivitySignedUp(String activityId) async {
    final signedUpActivities = await getSignedUpActivities();
    return signedUpActivities.contains(activityId);
  }

  // 报名活动
  static Future<bool> signUpActivity(String activityId) async {
    try {
      // 检查是否已经报名
      if (await isActivitySignedUp(activityId)) {
        return false; // 已经报名
      }

      // 检查报名限制
      if (!await SignupLimitService.canSignUp()) {
        return false; // 超出限制
      }

      // 添加到报名列表
      final signedUpActivities = await getSignedUpActivities();
      signedUpActivities.add(activityId);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_signupKey, jsonEncode(signedUpActivities));

      // 增加报名次数
      await SignupLimitService.incrementSignupCount();

      return true;
    } catch (e) {
      print('报名活动错误: $e');
      return false;
    }
  }

  // 获取今日剩余报名次数
  static Future<int> getRemainingSignupsToday() async {
    return await SignupLimitService.getRemainingSignups();
  }

  // 获取今日已报名次数
  static Future<int> getTodaySignupCount() async {
    return await SignupLimitService.getTodaySignupCount();
  }
}
