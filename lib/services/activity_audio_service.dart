import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ActivityAudioService {
  static final ActivityAudioService _instance = ActivityAudioService._internal();
  factory ActivityAudioService() => _instance;
  ActivityAudioService._internal();

  AudioPlayer? _audioPlayer;
  String? _currentAudioFile;
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // 播放状态监听器
  final StreamController<bool> _playingStateController = StreamController<bool>.broadcast();
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController = StreamController<Duration>.broadcast();

  // 获取播放状态流
  Stream<bool> get playingStateStream => _playingStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;

  // 获取当前状态
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  String? get currentAudioFile => _currentAudioFile;

  // 播放音频
  Future<void> playAudio(String audioFile) async {
    try {
      print('ActivityAudioService: 开始播放音频: $audioFile');
      
      // 如果正在播放不同的音频，先停止当前播放
      if (_currentAudioFile != null && _currentAudioFile != audioFile) {
        print('ActivityAudioService: 停止当前音频: $_currentAudioFile');
        await stopAudio();
      }

      // 如果还没有创建播放器，创建一个
      if (_audioPlayer == null) {
        print('ActivityAudioService: 创建新的音频播放器');
        _audioPlayer = AudioPlayer();
        _setupAudioPlayer();
      }

      // 如果当前音频已暂停，恢复播放
      if (_currentAudioFile == audioFile && _isPaused) {
        print('ActivityAudioService: 恢复播放音频: $audioFile');
        await _audioPlayer!.resume();
        _isPaused = false;
        _isPlaying = true;
        _playingStateController.add(true);
        return;
      }

      // 播放新音频
      final assetPath = 'audio/$audioFile';
      print('ActivityAudioService: 播放新音频，路径: $assetPath');
      await _audioPlayer!.play(AssetSource(assetPath));
      _currentAudioFile = audioFile;
      _isPlaying = true;
      _isPaused = false;
      _playingStateController.add(true);
      print('ActivityAudioService: 音频播放成功: $audioFile');
    } catch (e) {
      print('ActivityAudioService: 播放音频失败: $e');
      _playingStateController.add(false);
    }
  }

  // 暂停音频
  Future<void> pauseAudio() async {
    if (_audioPlayer != null && _isPlaying) {
      try {
        await _audioPlayer!.pause();
        _isPlaying = false;
        _isPaused = true;
        _playingStateController.add(false);
      } catch (e) {
        print('暂停音频失败: $e');
      }
    }
  }

  // 恢复音频
  Future<void> resumeAudio() async {
    if (_audioPlayer != null && _isPaused) {
      try {
        await _audioPlayer!.resume();
        _isPlaying = true;
        _isPaused = false;
        _playingStateController.add(true);
      } catch (e) {
        print('恢复音频失败: $e');
      }
    }
  }

  // 停止音频
  Future<void> stopAudio() async {
    if (_audioPlayer != null) {
      try {
        await _audioPlayer!.stop();
        _isPlaying = false;
        _isPaused = false;
        _currentPosition = Duration.zero;
        _currentAudioFile = null;
        _playingStateController.add(false);
        _positionController.add(Duration.zero);
      } catch (e) {
        print('停止音频失败: $e');
      }
    }
  }

  // 设置音频播放器
  void _setupAudioPlayer() {
    if (_audioPlayer == null) return;

    // 监听播放位置变化
    _audioPlayer!.onPositionChanged.listen((position) {
      _currentPosition = position;
      _positionController.add(position);
    });

    // 监听音频总时长
    _audioPlayer!.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      _durationController.add(duration);
    });

    // 监听播放状态变化
    _audioPlayer!.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          _isPlaying = true;
          _isPaused = false;
          _playingStateController.add(true);
          break;
        case PlayerState.paused:
          _isPlaying = false;
          _isPaused = true;
          _playingStateController.add(false);
          break;
        case PlayerState.stopped:
          _isPlaying = false;
          _isPaused = false;
          _playingStateController.add(false);
          break;
        case PlayerState.completed:
          _isPlaying = false;
          _isPaused = false;
          _playingStateController.add(false);
          // 播放完成后自动重播
          _autoReplay();
          break;
        default:
          break;
      }
    });
  }

  // 自动重播
  void _autoReplay() {
    if (_currentAudioFile != null && _audioPlayer != null) {
      print('ActivityAudioService: 自动重播音频: $_currentAudioFile');
      // 延迟一小段时间后重新播放
      Future.delayed(const Duration(milliseconds: 500), () {
        playAudio(_currentAudioFile!);
      });
    }
  }

  // 检查音频文件是否存在
  bool hasAudioFile(String? audioFile) {
    return audioFile != null && audioFile.isNotEmpty;
  }

  // 释放资源
  void dispose() {
    stopAudio();
    _audioPlayer?.dispose();
    _audioPlayer = null;
    _playingStateController.close();
    _positionController.close();
    _durationController.close();
  }
}
