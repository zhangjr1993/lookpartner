import 'package:flutter/material.dart';

class AppSizes {
  // 获取屏幕宽度
  static double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  
  // 获取屏幕高度
  static double getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  
  // iOS底部安全距离
  static double getBottomSafeArea(BuildContext context) => MediaQuery.of(context).padding.bottom;
  
  // iOS导航条高度
  static const double navigationBarHeight = 44.0;
  
  // iOS状态栏高度
  static double getStatusBarHeight(BuildContext context) => MediaQuery.of(context).padding.top;
}
