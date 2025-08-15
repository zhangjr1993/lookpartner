import 'package:shared_preferences/shared_preferences.dart';
import 'current_user_service.dart';

class DiamondService {
  static const String _diamondBalanceKey = 'diamond_balance_v2';
  static const int _messageCost = 10; // 每条消息10钻石
  
  // 获取用户钻石余额
  static Future<int> getDiamondBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_diamondBalanceKey) ?? 0;
  }
  
  // 设置用户钻石余额
  static Future<void> setDiamondBalance(int balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_diamondBalanceKey, balance);
  }
  
  // 增加钻石余额
  static Future<void> addDiamonds(int amount) async {
    final currentBalance = await getDiamondBalance();
    await setDiamondBalance(currentBalance + amount);
  }
  
  // 扣除钻石余额
  static Future<bool> deductDiamonds(int amount) async {
    final currentBalance = await getDiamondBalance();
    if (currentBalance >= amount) {
      await setDiamondBalance(currentBalance - amount);
      return true;
    }
    return false;
  }
  
  // 检查是否有足够的钻石发送消息
  static Future<bool> canSendMessage() async {
    // VIP用户免费发送消息
    final isVipValid = await CurrentUserService.isVipValid();
    if (isVipValid) {
      return true;
    }
    
    // 非VIP用户检查钻石余额
    final balance = await getDiamondBalance();
    return balance >= _messageCost;
  }
  
  // 发送消息（扣除钻石）
  static Future<bool> sendMessage() async {
    // VIP用户免费
    final isVipValid = await CurrentUserService.isVipValid();
    if (isVipValid) {
      return true;
    }
    
    // 非VIP用户扣除钻石
    return await deductDiamonds(_messageCost);
  }
  
  // 获取消息费用
  static int getMessageCost() {
    return _messageCost;
  }
  
  // 获取剩余可发送消息数量
  static Future<int> getRemainingMessages() async {
    // VIP用户无限制
    final isVipValid = await CurrentUserService.isVipValid();
    if (isVipValid) {
      return -1; // -1表示无限制
    }
    
    final balance = await getDiamondBalance();
    return balance ~/ _messageCost; // 整除
  }
  
  // 重置钻石余额（用于测试）
  static Future<void> resetDiamondBalance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_diamondBalanceKey);
  }
}
