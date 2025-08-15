import 'package:flutter/material.dart';
import 'dart:math' as math;

class BouncingMusicNote extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  final double size;

  const BouncingMusicNote({
    super.key,
    required this.isPlaying,
    required this.onTap,
    this.size = 60.0,
  });

  @override
  State<BouncingMusicNote> createState() => _BouncingMusicNoteState();
}

class _BouncingMusicNoteState extends State<BouncingMusicNote>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _colorController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotationAnimation;

  // 暖色区间颜色
  final List<Color> _warmColors = [
    const Color(0xFFFF6B6B), // 红色
    const Color(0xFFFF8E53), // 橙色
    const Color(0xFFFFB74D), // 深橙色
    const Color(0xFFFFD54F), // 黄色
    const Color(0xFFFF8A80), // 粉红色
    const Color(0xFFE57373), // 浅红色
    const Color(0xFFFFAB91), // 浅橙色
    const Color(0xFFFFCC02), // 金黄色
  ];

  @override
  void initState() {
    super.initState();
    
    // 缩放动画控制器 - 从0~1~0~1来回缩放
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // 颜色变化动画控制器
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // 旋转动画控制器 - 一直360°旋转
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // 缩放动画：从0~1~0~1来回缩放，使用正弦波实现平滑的来回缩放
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // 颜色变化动画：在暖色区间循环
    _colorAnimation = ColorTween(
      begin: _warmColors[0],
      end: _warmColors[1],
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    // 旋转动画：一直360°旋转
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0 * math.pi, // 2π = 360°
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear, // 线性曲线确保匀速旋转
    ));

    // 如果正在播放，启动动画
    if (widget.isPlaying) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(BouncingMusicNote oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 播放状态改变时，启动或停止动画
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  void _startAnimations() {
    _scaleController.repeat();
    _colorController.repeat();
    _rotationController.repeat();
  }

  void _stopAnimations() {
    _scaleController.stop();
    _colorController.stop();
    _rotationController.stop();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _colorController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleController, _colorController, _rotationController]),
        builder: (context, child) {
          // 计算缩放效果：使用正弦波实现0~1~0~1的来回缩放
          final scaleValue = (math.sin(_scaleController.value * math.pi * 2) + 1) / 2; // 将-1~1转换为0~1
          final currentScale = 0.6 + scaleValue * 0.4; // 基础缩放0.6，最大到1.0
          
          // 计算颜色
          final colorIndex = (_colorController.value * _warmColors.length) % _warmColors.length;
          final currentColor = _warmColors[colorIndex.floor()];
          
          // 计算旋转角度
          final rotationAngle = _rotationAnimation.value;
          
          return Transform.rotate(
            angle: rotationAngle,
            child: Transform.scale(
              scale: currentScale,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: currentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: currentColor.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  widget.isPlaying ? Icons.pause : Icons.music_note,
                  color: Colors.white,
                  size: widget.size * 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
