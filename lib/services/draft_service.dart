import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../pages/release_page.dart';

class DraftData {
  final String title;
  final String description;
  final String location;
  final DateTime? selectedDateTime;
  final String? coverImagePath;
  final String? selectedActivityType;
  final ReleaseType releaseType;

  DraftData({
    required this.title,
    required this.description,
    required this.location,
    this.selectedDateTime,
    this.coverImagePath,
    this.selectedActivityType,
    required this.releaseType,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'selectedDateTime': selectedDateTime?.millisecondsSinceEpoch,
      'coverImagePath': coverImagePath,
      'selectedActivityType': selectedActivityType,
      'releaseType': releaseType.index,
    };
  }

  factory DraftData.fromJson(Map<String, dynamic> json) {
    return DraftData(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      selectedDateTime: json['selectedDateTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['selectedDateTime'])
          : null,
      coverImagePath: json['coverImagePath'],
      selectedActivityType: json['selectedActivityType'],
      releaseType: ReleaseType.values[json['releaseType'] ?? 0],
    );
  }
}

class DraftService {
  static const String _draftFileName = 'release_draft.json';

  // 保存草稿
  static Future<void> saveDraft(DraftData draftData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_draftFileName');
      
      final jsonString = jsonEncode(draftData.toJson());
      await file.writeAsString(jsonString);
      
      print('草稿保存成功');
    } catch (e) {
      print('保存草稿失败: $e');
    }
  }

  // 加载草稿
  static Future<DraftData?> loadDraft() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_draftFileName');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString);
        return DraftData.fromJson(jsonData);
      }
    } catch (e) {
      print('加载草稿失败: $e');
    }
    return null;
  }

  // 删除草稿
  static Future<void> deleteDraft() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_draftFileName');
      
      if (await file.exists()) {
        await file.delete();
        print('草稿删除成功');
      }
    } catch (e) {
      print('删除草稿失败: $e');
    }
  }

  // 检查是否有草稿
  static Future<bool> hasDraft() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_draftFileName');
      return await file.exists();
    } catch (e) {
      print('检查草稿失败: $e');
      return false;
    }
  }

  // 检查草稿内容是否非空
  static bool isDraftNotEmpty(DraftData draftData) {
    return draftData.title.isNotEmpty ||
           draftData.description.isNotEmpty ||
           draftData.location.isNotEmpty ||
           draftData.selectedDateTime != null ||
           draftData.coverImagePath != null ||
           draftData.selectedActivityType != null;
  }
}
