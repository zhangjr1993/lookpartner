import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';

class ActivityService {
  static const String _dbKey = 'activities_db_v3'; // 更新版本号，强制重新加载数据

  static Future<List<ActivityModel>> loadFromAssets() async {
    print('ActivityService: 开始从assets加载数据');
    final String raw = await rootBundle.loadString('assets/data/activities_v3.json');
    print('ActivityService: 读取到的原始JSON长度: ${raw.length}');
    print('ActivityService: JSON前100个字符: ${raw.substring(0, raw.length > 100 ? 100 : raw.length)}');
    
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    print('ActivityService: 从JSON解析到 ${list.length} 个活动');
    
    final activities = list.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
    
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
  }

  static Future<void> saveAllToLocal(List<ActivityModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_dbKey, jsonStr);
  }

  static Future<List<ActivityModel>> readAllFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_dbKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
    return list.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // 清空本地缓存
  static Future<void> clearLocalCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dbKey);
    print('ActivityService: 已清空本地缓存');
  }
}
