import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';

class ActivityService {
  static const String _dbKey = 'activities_db_v3'; // 更新版本号，强制重新加载数据

  static Future<List<ActivityModel>> loadFromAssets() async {
    print('ActivityService: 开始从assets加载数据');
    
    try {
      // 检查文件是否存在
      print('ActivityService: 检查assets/data/activities_v3.json文件...');
      
      final String raw = await rootBundle.loadString('assets/data/activities_v3.json');
      print('ActivityService: 成功读取JSON文件，长度: ${raw.length}');
      print('ActivityService: JSON前100个字符: ${raw.substring(0, raw.length > 100 ? 100 : raw.length)}');
      
      if (raw.isEmpty) {
        throw Exception('JSON文件内容为空');
      }
      
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      print('ActivityService: 从JSON解析到 ${list.length} 个活动');
      
      if (list.isEmpty) {
        throw Exception('JSON解析后活动列表为空');
      }
      
      final activities = list.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
      print('ActivityService: 成功创建 ${activities.length} 个ActivityModel实例');
      
      // 检查原始JSON数据中的音频文件字段
      print('ActivityService: 检查原始JSON数据中的音频文件字段:');
      for (int i = 0; i < list.length; i++) {
        final item = list[i] as Map<String, dynamic>;
        final id = item['id'];
        final audioFile = item['audio_file'];
        print('ActivityService: 原始JSON - 活动 $id 的 audio_file: ${audioFile ?? "null"}');
      }
      
      // 检查解析后的活动模型中的音频文件字段
      print('ActivityService: 检查解析后的活动模型中的音频文件字段:');
      for (var activity in activities) {
        print('ActivityService: 模型 - 活动 ${activity.id} 的 audioFile: ${activity.audioFile ?? "null"}');
        if (activity.audioFile != null) {
          print('ActivityService: ✓ 活动 ${activity.id} 有音频文件: ${activity.audioFile}');
        } else {
          print('ActivityService: ✗ 活动 ${activity.id} 没有音频文件');
        }
      }
      
      return activities;
      
    } catch (e, stackTrace) {
      print('ActivityService: 从assets加载数据失败: $e');
      print('ActivityService: 错误堆栈: $stackTrace');
      
      // 重新抛出异常，让调用者处理
      throw Exception('从assets加载活动数据失败: $e');
    }
  }

  static Future<void> saveAllToLocal(List<ActivityModel> items) async {
    try {
      print('ActivityService: 开始保存 ${items.length} 个活动到本地缓存...');
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(items.map((e) => e.toJson()).toList());
      await prefs.setString(_dbKey, jsonStr);
      print('ActivityService: 成功保存 ${items.length} 个活动到本地缓存');
    } catch (e, stackTrace) {
      print('ActivityService: 保存数据到本地缓存失败: $e');
      print('ActivityService: 错误堆栈: $stackTrace');
      // 不抛出异常，让调用者继续使用数据
      print('ActivityService: 缓存保存失败，但不影响数据使用');
    }
  }

  static Future<List<ActivityModel>> readAllFromLocal() async {
    try {
      print('ActivityService: 尝试从本地缓存读取数据...');
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_dbKey);
      
      if (jsonStr == null || jsonStr.isEmpty) {
        print('ActivityService: 本地缓存中没有数据');
        return [];
      }
      
      print('ActivityService: 从本地缓存读取到JSON字符串，长度: ${jsonStr.length}');
      
      final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
      print('ActivityService: 从本地缓存解析到 ${list.length} 个活动');
      
      final activities = list.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
      print('ActivityService: 成功从本地缓存恢复 ${activities.length} 个ActivityModel实例');
      
      return activities;
      
    } catch (e, stackTrace) {
      print('ActivityService: 从本地缓存读取数据失败: $e');
      print('ActivityService: 错误堆栈: $stackTrace');
      print('ActivityService: 返回空列表，不影响应用运行');
      return [];
    }
  }

  // 清空本地缓存
  static Future<void> clearLocalCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dbKey);
    print('ActivityService: 已清空本地缓存');
  }
}
