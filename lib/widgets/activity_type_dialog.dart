import 'package:flutter/material.dart';

class ActivityTypeDialog extends StatelessWidget {
  final Function(String) onTypeSelected;
  
  const ActivityTypeDialog({
    super.key,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 按钮尺寸按屏幕比例换算 (75, 91)
    final buttonWidth = screenWidth * 75 / 375; // 假设设计稿宽度375
    final buttonHeight = screenHeight * 91 / 812; // 假设设计稿高度812
    
    return Container(
      color: Colors.black.withValues(alpha: 0.5), // 黑色半透明背景
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: screenHeight * 2 / 3, // 高度为屏高的2/3
            decoration: const BoxDecoration(
              color: Colors.white, // 白色容器视图
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), // 左上圆角16
                topRight: Radius.circular(16), // 右上圆角16
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题：请选择你的搭子类型
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 24), // 左侧在容器16，上方在容器顶部24
                  child: const Text(
                    '请选择你的搭子类型',
                    style: TextStyle(
                      color: Color(0xFF171717), // 色号#171717
                      fontSize: 18, // 字号18
                      fontWeight: FontWeight.bold, // 粗体
                    ),
                  ),
                ),
                
                // 描述
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8), // 左侧在容器16，上方在标题下方8
                  child: Text(
                    '最多可选择一种类型',
                    style: TextStyle(
                      color: const Color(0xFF171717).withValues(alpha: 0.4), // 色号#171717不透明度0.4
                      fontSize: 15, // 字号15
                      fontWeight: FontWeight.w600, // 中粗
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 16个按钮网格
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 13, // 按钮左右间距13
                      mainAxisSpacing: 13, // 按钮上下间距13
                      childAspectRatio: buttonWidth / buttonHeight, // 按钮尺寸比例
                    ),
                    itemCount: _activityTypes.length,
                    itemBuilder: (context, index) {
                      final type = _activityTypes[index];
                      return GestureDetector(
                        onTap: () {
                          onTypeSelected(type['name']!);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: Image.asset(
                            type['image']!,
                            width: buttonWidth,
                            height: buttonHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) {
                              return Container(
                                width: buttonWidth,
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      type['icon'],
                                      size: 24,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      type['name']!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // 底部安全区域
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 16种活动类型数据，直接加载图片
  static const List<Map<String, dynamic>> _activityTypes = [
    {
      'name': '宠物',
      'image': 'assets/images/pubAssets/btn_release_friends_dw.webp',
      'icon': Icons.pets,
    },
    {
      'name': '电影',
      'image': 'assets/images/pubAssets/btn_release_friends_dy.webp',
      'icon': Icons.movie,
    },
    {
      'name': '干饭',
      'image': 'assets/images/pubAssets/btn_release_friends_gf.webp',
      'icon': Icons.restaurant,
    },
    {
      'name': '逛街',
      'image': 'assets/images/pubAssets/btn_release_friends_gj.webp',
      'icon': Icons.shopping_bag,
    },
    {
      'name': '喝酒',
      'image': 'assets/images/pubAssets/btn_release_friends_hj.webp',
      'icon': Icons.local_bar,
    },
    {
      'name': '户外',
      'image': 'assets/images/pubAssets/btn_release_friends_hw.webp',
      'icon': Icons.landscape,
    },
    {
      'name': 'K歌',
      'image': 'assets/images/pubAssets/btn_release_friends_kg.webp',
      'icon': Icons.mic,
    },
    {
      'name': '聊天',
      'image': 'assets/images/pubAssets/btn_release_friends_lt.webp',
      'icon': Icons.chat_bubble,
    },
    {
      'name': '旅游',
      'image': 'assets/images/pubAssets/btn_release_friends_ly.webp',
      'icon': Icons.flight,
    },
    {
      'name': '摄影',
      'image': 'assets/images/pubAssets/btn_release_friends_sy.webp',
      'icon': Icons.camera_alt,
    },
    {
      'name': '学习',
      'image': 'assets/images/pubAssets/btn_release_friends_xx.webp',
      'icon': Icons.school,
    },
    {
      'name': '运动',
      'image': 'assets/images/pubAssets/btn_release_friends_yd.webp',
      'icon': Icons.directions_run,
    },
    {
      'name': '游戏',
      'image': 'assets/images/pubAssets/btn_release_friends_yx.webp',
      'icon': Icons.games,
    },
    {
      'name': '音乐',
      'image': 'assets/images/pubAssets/btn_release_friends_yy.webp',
      'icon': Icons.headphones,
    },
    {
      'name': '追剧',
      'image': 'assets/images/pubAssets/btn_release_friends_zj.webp',
      'icon': Icons.tv,
    },
    {
      'name': '桌游',
      'image': 'assets/images/pubAssets/btn_release_friends_zy.webp',
      'icon': Icons.casino,
    },
  ];
}
