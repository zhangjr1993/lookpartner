import 'package:flutter/services.dart';

class NativePermissionService {
  static const MethodChannel _channel = MethodChannel('com.lookpartner.permissions');

  /// 请求相机权限 - 主动触发iOS系统权限弹窗
  static Future<bool> requestCameraPermission() async {
    try {
      final String result = await _channel.invokeMethod('requestCameraPermission');
      return result == 'granted';
    } on PlatformException catch (e) {
      print('请求相机权限失败: $e');
      return false;
    }
  }

  /// 请求相册权限 - 主动触发iOS系统权限弹窗
  static Future<bool> requestPhotoPermission() async {
    try {
      final String result = await _channel.invokeMethod('requestPhotoPermission');
      return result == 'granted';
    } on PlatformException catch (e) {
      print('请求相册权限失败: $e');
      return false;
    }
  }
}






