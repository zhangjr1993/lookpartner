import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class NetworkService {
  // 智谱API配置
  static const String baseUrl = 'https://open.bigmodel.cn/api/paas/v4';
  static const String apiKey = 'b3cfcd0c319b41518267adb7d8797550.ehXXpLUBTZHtaHsr';
  static const String model = 'glm-4-flash';
  
  // 获取网络权限测试接口
  static Future<bool> testNetworkPermission() async {
    try {
      final response = await http.get(
        Uri.parse('https://httpbin.org/get'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('网络权限测试失败: $e');
      return false;
    }
  }
  
  // 智谱API调用示例
  static Future<Map<String, dynamic>> callZhipuAPI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'stream': false,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API调用失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('网络请求失败: $e');
    }
  }
}
