import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants/app_colors.dart';
import '../models/music_model.dart';
import '../services/music_service.dart';

class MyMusicPage extends StatefulWidget {
  const MyMusicPage({super.key});

  @override
  State<MyMusicPage> createState() => _MyMusicPageState();
}

class _MyMusicPageState extends State<MyMusicPage> {
  List<MusicModel> _musicList = [];
  bool _loading = true;
  
  // 音频播放器
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // 播放状态
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  MusicModel? _currentMusic;
  
  // 播放进度更新定时器
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _loadMusicList();
    _setupAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // 设置音频播放器
  void _setupAudioPlayer() {
    // 监听播放位置变化
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // 监听音频总时长
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // 监听播放状态变化
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
        
        // 播放完成后自动暂停
        if (state == PlayerState.completed) {
          _pauseMusic();
        }
      }
    });
  }

  // 加载音乐列表
  Future<void> _loadMusicList() async {
    try {
      final musicList = await MusicService.getMusicList();
      setState(() {
        _musicList = musicList;
        _loading = false;
      });
    } catch (e) {
      print('加载音乐列表失败: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  // 播放音乐
  Future<void> _playMusic(MusicModel music) async {
    try {
      if (_currentMusic?.id != music.id) {
        // 播放新的音乐
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(music.filePath));
        setState(() {
          _currentMusic = music;
        });
      } else {
        // 继续播放当前音乐
        await _audioPlayer.resume();
      }
    } catch (e) {
      print('播放音乐失败: $e');
      _showToast('播放失败: $e');
    }
  }

  // 暂停音乐
  Future<void> _pauseMusic() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('暂停音乐失败: $e');
    }
  }

  // 停止音乐
  Future<void> _stopMusic() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _currentPosition = Duration.zero;
        _currentMusic = null;
      });
    } catch (e) {
      print('停止音乐失败: $e');
    }
  }

  // 跳转到指定位置
  Future<void> _seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('跳转播放位置失败: $e');
    }
  }

  // 格式化时间
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // 显示提示信息
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '我的音乐',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF9D6B7B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // 退出页面时自动暂停
            _pauseMusic();
            Navigator.pop(context);
          },
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 当前播放控制区域
                if (_currentMusic != null) _buildNowPlayingSection(),
                
                // 音乐列表
                Expanded(child: _buildMusicList()),
              ],
            ),
    );
  }

  // 当前播放控制区域
  Widget _buildNowPlayingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9D6B7B), Color(0xFF7B889F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 音乐信息
          Text(
            _currentMusic!.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currentMusic!.artist,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // 进度条
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white30,
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: _totalDuration.inMilliseconds > 0
                  ? _currentPosition.inMilliseconds.toDouble()
                  : 0.0,
              max: _totalDuration.inMilliseconds.toDouble(),
              onChanged: (value) {
                final newPosition = Duration(milliseconds: value.toInt());
                _seekTo(newPosition);
              },
            ),
          ),
          
          // 时间显示
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatDuration(_totalDuration),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 播放控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _stopMusic,
                icon: const Icon(
                  Icons.stop_circle_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: _isPlaying ? _pauseMusic : () => _playMusic(_currentMusic!),
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 音乐列表
  Widget _buildMusicList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _musicList.length,
      itemBuilder: (context, index) {
        final music = _musicList[index];
        final isCurrentMusic = _currentMusic?.id == music.id;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isCurrentMusic ? const Color(0xFFF0F0F0) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrentMusic ? const Color(0xFF9D6B7B) : Colors.grey.shade200,
              width: isCurrentMusic ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF9D6B7B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 24,
              ),
            ),
            title: Text(
              music.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCurrentMusic ? FontWeight.bold : FontWeight.w500,
                color: isCurrentMusic ? const Color(0xFF9D6B7B) : Colors.black87,
              ),
            ),
            subtitle: Text(
              music.artist,
              style: TextStyle(
                fontSize: 14,
                color: isCurrentMusic ? const Color(0xFF9D6B7B).withValues(alpha: 0.7) : Colors.grey.shade600,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                if (isCurrentMusic && _isPlaying) {
                  _pauseMusic();
                } else {
                  _playMusic(music);
                }
              },
              icon: Icon(
                isCurrentMusic && _isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: const Color(0xFF9D6B7B),
                size: 32,
              ),
            ),
            onTap: () {
              if (isCurrentMusic && _isPlaying) {
                _pauseMusic();
              } else {
                _playMusic(music);
              }
            },
          ),
        );
      },
    );
  }
}
