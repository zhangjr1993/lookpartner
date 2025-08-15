import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/music_model.dart';

class MusicService {
  static List<MusicModel> _musicList = [];
  static bool _initialized = false;

  // 获取音乐列表
  static Future<List<MusicModel>> getMusicList() async {
    if (!_initialized) {
      await _initializeMusicList();
    }
    return _musicList;
  }

  // 初始化音乐列表
  static Future<void> _initializeMusicList() async {
    try {
      // 从assets/audio目录读取音乐文件
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      final audioFiles = manifestMap.keys
          .where((String key) => key.startsWith('assets/audio/') && key.endsWith('.mp3'))
          .toList();

      _musicList = audioFiles.map((filePath) {
        final fileName = filePath.split('/').last.replaceAll('.mp3', '');
        return MusicModel(
          id: fileName,
          title: _getMusicTitle(fileName),
          artist: _getMusicArtist(fileName),
          filePath: filePath.replaceFirst('assets/', ''), // 移除assets/前缀
          duration: Duration.zero, // 实际播放时获取
        );
      }).toList();

      _initialized = true;
    } catch (e) {
      print('初始化音乐列表失败: $e');
      _musicList = [];
    }
  }

  // 根据文件名获取音乐标题
  static String _getMusicTitle(String fileName) {
    switch (fileName) {
      case 'haixiuboy':
        return '海秀男孩';
      case 'siyibeisong':
        return '四亿悲伤';
      case 'beisongguofeng':
        return '悲伤国风';
      case 'konglingshenmi':
        return '空灵神秘';
      case 'dreamzhanf':
        return '梦想绽放';
      case 'konglingkeji':
        return '空灵科技';
      case 'heijiaochangp':
        return '黑胶唱片';
      case 'shidaihuiyi':
        return '时代回忆';
      default:
        return fileName;
    }
  }

  // 根据文件名获取艺术家
  static String _getMusicArtist(String fileName) {
    switch (fileName) {
      case 'haixiuboy':
        return '海秀音乐';
      case 'siyibeisong':
        return '四亿音乐';
      case 'beisongguofeng':
        return '国风音乐';
      case 'konglingshenmi':
        return '空灵音乐';
      case 'dreamzhanf':
        return '梦想音乐';
      case 'konglingkeji':
        return '科技音乐';
      case 'heijiaochangp':
        return '黑胶音乐';
      case 'shidaihuiyi':
        return '回忆音乐';
      default:
        return '未知艺术家';
    }
  }

  // 根据ID获取音乐
  static MusicModel? getMusicById(String id) {
    try {
      return _musicList.firstWhere((music) => music.id == id);
    } catch (e) {
      return null;
    }
  }

  // 清空音乐列表
  static void clearMusicList() {
    _musicList.clear();
    _initialized = false;
  }
}
