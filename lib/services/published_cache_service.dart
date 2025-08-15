import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/activity.dart';
import '../pages/release_page.dart';

class PublishedCacheService {
  static const String _publishedFileName = 'published_activities.json';

  // 保存发布的活动到缓存
  static Future<void> savePublishedActivity({
    required String title,
    required String description,
    required String location,
    required DateTime eventTime,
    String? coverImagePath,
    String? selectedActivityType,
    required ReleaseType releaseType,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_publishedFileName');
      
      // 读取现有数据
      List<Map<String, dynamic>> publishedList = [];
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);
        if (data is List) {
          publishedList = List<Map<String, dynamic>>.from(data);
        }
      }
      
      // 创建新的活动数据
      final newActivity = {
        'id': 'published_${DateTime.now().millisecondsSinceEpoch}',
        'title': title,
        'description': description,
        'location': location,
        'eventTime': eventTime.millisecondsSinceEpoch,
        'coverImagePath': coverImagePath,
        'selectedActivityType': selectedActivityType,
        'releaseType': releaseType.index,
        'publishedAt': DateTime.now().millisecondsSinceEpoch,
        'status': 'pending_review', // 审核中状态
      };
      
      // 添加到列表开头（最新的在前面）
      publishedList.insert(0, newActivity);
      
      // 保存到文件
      final jsonString = jsonEncode(publishedList);
      await file.writeAsString(jsonString);
      
      print('发布活动已保存到缓存: $title');
    } catch (e) {
      print('保存发布活动失败: $e');
    }
  }

  // 获取所有发布的活动
  static Future<List<ActivityModel>> getPublishedActivities() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_publishedFileName');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);
        
        if (data is List) {
          final publishedList = List<Map<String, dynamic>>.from(data);
          
          return publishedList.map((item) {
            return ActivityModel(
              id: item['id'] ?? 'unknown',
              title: item['title'] ?? '',
              description: item['description'] ?? '',
              cover: _getCoverForType(item['selectedActivityType'], item['coverImagePath']),
              location: item['location'] ?? '',
              eventTime: item['eventTime'] ?? DateTime.now().millisecondsSinceEpoch,
              requiredPeople: 1,
              maxPeople: 2,
              joinedPeople: 0,
              publisherGender: '女', // 默认值，后续可以从用户信息获取
              publisherNickname: '寒寒', // 默认值，后续可以从用户信息获取
              publisherAvatar: 'activity_sg_1001.webp',
              publisherId: 'user_001',
              type: ReleaseType.values[item['releaseType'] ?? 0] == ReleaseType.buddy 
                  ? ActivityType.buddy : ActivityType.normal,
              isJoined: false,
              personalityTag: 'ENFP',
              activityType: item['selectedActivityType'] ?? '活动',
              requirements: item['status'] == 'pending_review' ? '审核中' : '已发布',
              registeredCount: 0,
              isDraft: false,
            );
          }).toList();
        }
      }
    } catch (e) {
      print('获取发布活动失败: $e');
    }
    return [];
  }

  // 根据活动类型获取封面
  static String _getCoverForType(String? activityType, String? coverImagePath) {
    if (coverImagePath != null && coverImagePath.isNotEmpty) {
      return 'activity_sg_1001.webp'; // 模拟封面
    }
    
    // 根据搭子类型返回对应图片
    switch (activityType) {
      case '运动':
        return 'activity_sg_1001.webp';
      case '电影':
        return 'activity_sg_1002.webp';
      case '干饭':
        return 'activity_sg_1003.webp';
      default:
        return 'activity_sg_1001.webp';
    }
  }

  // 清空发布缓存
  static Future<void> clearPublishedCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_publishedFileName');
      
      if (await file.exists()) {
        await file.delete();
        print('发布缓存已清空');
      }
    } catch (e) {
      print('清空发布缓存失败: $e');
    }
  }

  // 检查是否有发布的活动
  static Future<bool> hasPublishedActivities() async {
    try {
      final activities = await getPublishedActivities();
      return activities.isNotEmpty;
    } catch (e) {
      print('检查发布活动失败: $e');
      return false;
    }
  }
}
