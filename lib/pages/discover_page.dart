import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../services/native_permission_service.dart';
import 'buddy_detail_page.dart';
import 'normal_detail_page.dart';
import 'my_activities_page.dart';
import 'my_music_page.dart';
import 'message_list_page.dart';
import 'mbti_test_page.dart';
import 'feedback_page.dart';
import 'draft_page.dart';
import 'blacklist_page.dart';
import 'report_history_page.dart';
import 'chat_detail_page.dart';
import 'package:lookpartner/constants/app_colors.dart';
import 'package:lookpartner/constants/app_sizes.dart';
import 'package:lookpartner/models/activity.dart';
import 'package:lookpartner/services/signup_service.dart';
import 'package:lookpartner/services/current_user_service.dart';
import 'package:lookpartner/services/signup_limit_service.dart';
import 'package:lookpartner/services/keychain_service.dart';
import 'package:card_swiper/card_swiper.dart';
import 'dart:math';

class DiscoverPage extends StatefulWidget {
  final List<ActivityModel> activities;

  const DiscoverPage({super.key, required this.activities});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  String _userId = '';
  
  // 入场动画控制器
  late AnimationController _entranceController;
  late Animation<double> _emptyCard2Animation;
  late Animation<double> _emptyCard1Animation;
  late Animation<double> _mainCardAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeUserId();
    
    // 入场动画控制器
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 空卡片2入场动画 (0-500ms)
    _emptyCard2Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.33, curve: Curves.easeOut),
    ));
    
    // 空卡片1入场动画 (500-1000ms)
    _emptyCard1Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.33, 0.66, curve: Curves.easeOut),
    ));
    
    // 主卡片入场动画 (1000-1500ms)
    _mainCardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.66, 1.0, curve: Curves.easeOut),
    ));
    
    // 开始入场动画
    _startEntranceAnimation();
  }
  
  void _startEntranceAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _initializeUserId() async {
    final user = await KeychainService.getUser();
    if (user != null) {
      setState(() {
        _userId = user.userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DiscoverPage build: activities count = ${widget.activities.length}');
    print('DiscoverPage build: currentIndex = $_currentIndex');
    
    if (widget.activities.isEmpty) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                '暂无活动数据',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final screenWidth = AppSizes.getScreenWidth(context);
    final cardWidth = screenWidth - 32;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // 渐变背景图片
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/discoverAssets/bg_home_shadow.webp',
              width: AppSizes.getScreenWidth(context),
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stack) {
                return Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x33000000), Color(0x11000000)],
                    ),
                  ),
                );
              },
            ),
          ),
          
          Column(
            children: [
              // 顶部导航区域
              SizedBox(height: AppSizes.getStatusBarHeight(context) + 8),
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    // 左侧菜单按钮
                    GestureDetector(
                      onTap: _showDrawerMenu,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 12),
                        child: const Icon(
                          Icons.menu,
                          color: AppColors.primaryText,
                          size: 24,
                        ),
                      ),
                    ),
                    // 中间标题
                    const Expanded(
                      child: Center(
                        child: Text(
                          '发现',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // 右侧占位
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 21),
              
              // 卡片滑动区域 - 带入场动画和灰色背景卡片
              Expanded(
                child: AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 空卡片2 - 最先入场 (最浅灰色)
                          _buildEmptyCard(
                            width: cardWidth - 32,
                            color: const Color(0xFFE8E8E8),
                            bottomOffset: -12,
                            animation: _emptyCard2Animation,
                          ),
                          
                          // 空卡片1 - 第二个入场 (中灰色)
                          _buildEmptyCard(
                            width: cardWidth - 16,
                            color: const Color(0xFFAAAAAA),
                            bottomOffset: -6,
                            animation: _emptyCard1Animation,
                          ),
                          
                          // Swiper卡片 - 最后入场
                          if (_mainCardAnimation.value > 0)
                            _buildSwiperWithAnimation(cardWidth),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              SizedBox(height: AppSizes.getBottomSafeArea(context) + 22),
            ],
          ),
        ],
      ),
    );
  }

  // 构建空卡片（背景卡片）
  Widget _buildEmptyCard({
    required double width,
    required Color color,
    required double bottomOffset,
    required Animation<double> animation,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          bottom: bottomOffset,
          left: (AppSizes.getScreenWidth(context) - 32 - width) / 2,
          child: Transform.translate(
            offset: Offset(-100 * (1 - animation.value), 0), // 从左侧滑入
            child: Opacity(
              opacity: animation.value,
              child: Container(
                width: width,
                height: 560,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 构建带动画的Swiper
  Widget _buildSwiperWithAnimation(double cardWidth) {
    return AnimatedBuilder(
      animation: _mainCardAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            -100 * (1 - _mainCardAnimation.value),
            0,
          ),
          child: Opacity(
            opacity: _mainCardAnimation.value,
            child: Swiper(
              itemCount: widget.activities.length,
              itemBuilder: (context, index) {
                return _buildSwiperCard(widget.activities[index], cardWidth);
              },
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              loop: true, // 无限循环
              duration: 300, // 切换动画时长
              scrollDirection: Axis.horizontal, // 水平滑动
              viewportFraction: 0.9, // 卡片宽度占视口的90%
              scale: 0.9, // 缩放效果
              layout: SwiperLayout.STACK, // 堆叠布局
              itemWidth: cardWidth, // 设置卡片宽度
            ),
          ),
        );
      },
    );
  }

  // 构建Swiper卡片（保留以备后用）
  Widget _buildSwiperCard(ActivityModel activity, double cardWidth) {
    return GestureDetector(
      onTap: () => _onCardTap(activity),
      child: Container(
        width: cardWidth,
        height: 560,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // 封面图片
              Positioned.fill(
                child: Image.asset(
                  'assets/images/discoverAssets/${activity.cover}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade300,
                            Colors.purple.shade300,
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // 渐变阴影
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/discoverAssets/bg_discover_shadow.webp',
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stack) {
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // 内容区域
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 性格标签
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTextHighlight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activity.personalityTag,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // 用户昵称
                    Text(
                      activity.publisherNickname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // 用户性别+地址
                    Text(
                      '${activity.publisherGender} | ${activity.location}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 显示侧边栏菜单
  void _showDrawerMenu() async {
    // 获取用户信息
    final user = await KeychainService.getUser();
    final userName = user?.nickname;
    final userAvatar = (user != null && user.avatar.isNotEmpty) ? 'assets/images/${user.avatar}' : null;
    
    print('DiscoverPage: 侧边栏菜单用户信息:');
    print('  - userName: $userName');
    print('  - userAvatar: $userAvatar');
    print('  - 完整user: $user');
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return SidebarMenuWidget(
          userId: _userId,
          onMenuItemTap: (title) {
            _handleMenuItemTap(title);
          },
          onBottomMenuTap: (title) {
            _handleBottomMenuTap(title);
          },
          userAvatar: userAvatar,
          userName: userName,
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation1,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
    );
  }

  // 卡片点击事件
  void _onCardTap(ActivityModel activity) {
    if (activity.type == ActivityType.buddy) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BuddyDetailPage(activity: activity),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NormalDetailPage(activity: activity),
        ),
      );
    }
  }

  // 显示Toast提示
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 处理主菜单项点击
  void _handleMenuItemTap(String title) {
    switch (title) {
      case '我的活动':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyActivitiesPage()),
        );
        break;
      case '我的音乐':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyMusicPage()),
        );
        break;
      case '我的草稿':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DraftPage()),
        );
        break;
      case '我的消息':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MessageListPage()),
        );
        break;
      case '举报历史':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportHistoryPage()),
        );
        break;
      case '黑名单':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BlacklistPage()),
        );
        break;
    }
  }

  // 处理底部菜单点击
  void _handleBottomMenuTap(String title) {
    switch (title) {
      case 'MBTI测试':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MbtiTestPage()),
        );
        break;
      case '意见反馈':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FeedbackPage()),
        );
        break;
    }
  }
}

// 侧边栏菜单组件
class SidebarMenuWidget extends StatefulWidget {
  final String userId;
  final Function(String) onMenuItemTap;
  final Function(String) onBottomMenuTap;
  final String? userAvatar;
  final String? userName;
  
  const SidebarMenuWidget({
    super.key,
    required this.userId,
    required this.onMenuItemTap,
    required this.onBottomMenuTap,
    this.userAvatar,
    this.userName,
  });

  @override
  State<SidebarMenuWidget> createState() => _SidebarMenuWidgetState();
}

class _SidebarMenuWidgetState extends State<SidebarMenuWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': '我的活动', 'icon': Icons.event, 'section': 'main'},
    {'title': '我的音乐', 'icon': Icons.music_note, 'section': 'main'},
    {'title': '我的草稿', 'icon': Icons.edit_note, 'section': 'main'},
    {'title': '我的消息', 'icon': Icons.message, 'section': 'main'},
    {'title': '举报历史', 'icon': Icons.report, 'section': 'main'},
    {'title': '黑名单', 'icon': Icons.block, 'section': 'main'},
  ];
  
  final List<Map<String, dynamic>> _bottomMenuItems = [
    {'title': 'MBTI测试', 'icon': Icons.psychology},
    {'title': '意见反馈', 'icon': Icons.feedback},
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _menuItems.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 200 + (index * 100)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    // 依次启动动画
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 黑色半透明背景层
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        
        // 侧边栏菜单
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // 用户信息区域
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                    ),
                    child: Row(
                      children: [
                        widget.userAvatar != null && widget.userAvatar!.isNotEmpty
                            ? ClipOval(
                                child: Image.asset(
                                  widget.userAvatar!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) {
                                    return const CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.person, color: Colors.white),
                                    );
                                  },
                                ),
                              )
                            : const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName ?? '用户',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ID: ${widget.userId}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1),
                  
                  // 主菜单项
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: _menuItems.length,
                      itemBuilder: (context, index) {
                        final item = _menuItems[index];
                        return SlideTransition(
                          position: _animations[index],
                          child: ListTile(
                            leading: Icon(item['icon'], color: Colors.grey[600]),
                            title: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              widget.onMenuItemTap(item['title']);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const Divider(height: 1),
                  
                  // 底部菜单项
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: _bottomMenuItems.map((item) {
                        return ListTile(
                          leading: Icon(item['icon'], color: Colors.grey[600]),
                          title: Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onBottomMenuTap(item['title']);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

