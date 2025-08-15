import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../services/activity_service.dart';
import '../services/keychain_service.dart';
import '../services/current_user_service.dart';
import '../services/diamond_service.dart';
import '../services/user_info_service.dart';
import '../models/activity.dart';
import '../models/user_model.dart';
import '../widgets/app_menu_dialog.dart';
import 'discover_page.dart';
import 'my_page.dart';
import '../widgets/release_selection_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _loading = true;
  List<ActivityModel> _activities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      // 只有当不是发布按钮时才更新索引
      if (_tabController.index != 1) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      } else {
        // 如果是发布按钮，重置到当前页面
        _tabController.animateTo(_currentIndex);
      }
    });
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      print('HomePage: 开始加载活动数据...');
      
      // 初始化用户信息
      await _initializeUserInfo();
      
      // 强制清空本地缓存，确保从assets重新加载
      await ActivityService.clearLocalCache();
      print('HomePage: 已清空本地缓存');
      
      final list = await ActivityService.loadFromAssets();
      print('HomePage: 从assets加载到 ${list.length} 个活动');
      
      // 检查音频文件字段
      for (var activity in list) {
        if (activity.audioFile != null) {
          print('HomePage: 活动 ${activity.id} 有音频文件: ${activity.audioFile}');
        }
      }
      
      await ActivityService.saveAllToLocal(list);
      print('HomePage: 数据已保存到本地');
      _activities = list;
      print('HomePage: 设置_activities为 ${_activities.length} 个活动');
    } catch (e) {
      print('HomePage: 加载数据出错: $e');
      _activities = [];
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        print('HomePage: 数据加载完成，_loading设置为false');
      }
    }
  }

  // 初始化用户信息
  Future<void> _initializeUserInfo() async {
    try {
      // 从Keychain获取用户信息
      final user = await KeychainService.getUser();
      if (user != null) {
        print('HomePage: 从Keychain获取到用户信息:');
        print('  - 用户ID: ${user.userId}');
        print('  - 昵称: ${user.nickname}');
        print('  - 头像: ${user.avatar}');
        print('  - 年龄: ${user.age}');
        print('  - 城市: ${user.city}');
        print('  - 性格标签: ${user.personalityType}');
        print('  - 钻石: ${user.diamonds}');
        print('  - VIP状态: ${user.isVip}');
        
        // 设置当前用户ID
        await CurrentUserService.setCurrentUserId(user.userId);
        
        // 设置VIP状态
        await CurrentUserService.setCurrentUserVip(user.isVip);
        await CurrentUserService.setVipExpireTime(user.vipExpireTime);
        
        // 设置钻石余额
        await DiamondService.setDiamondBalance(user.diamonds);
        
        // 设置用户基本信息
        await UserInfoService.saveUserInfo({
          'nickname': user.nickname,
          'age': user.age,
          'avatar': user.avatar,
          'location': user.city,
          'personalityType': user.personalityType,
        });
        
        print('HomePage: 用户信息初始化完成');
      } else {
        print('HomePage: 没有找到用户信息，需要重新登录');
      }
    } catch (e) {
      print('HomePage: 初始化用户信息失败: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Column(
        children: [
          // 内容区域
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(), // 禁止滑动
                    children: [
                      DiscoverPage(activities: _activities),
                      _buildReleaseTab(),
                      _buildMineTab(),
                    ],
                  ),
          ),

          // TabBar
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50, // 从49增加到50，解决1像素溢出
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    labelColor: AppColors.primaryText,
                    unselectedLabelColor: AppColors.descriptionText,
                    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    labelPadding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.fill,
                    dividerColor: Colors.transparent,
                    onTap: (index) {
                      if (index == 1) {
                        // 点击发布按钮，显示发布选择弹窗
                        _showReleaseSelectionDialog();
                      } else {
                        // 其他tab正常切换
                        setState(() {
                          _currentIndex = index;
                        });
                      }
                    },
                    tabs: [
                      Tab(child: const Center(child: Text('活动'))),
                      Tab(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 1), // 减少顶部间距从2到1
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.buttonBackground,
                                  borderRadius: BorderRadius.circular(22.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.buttonBackground.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.add, color: AppColors.primaryText, size: 24),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(child: const Center(child: Text('我的'))),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppSizes.getBottomSafeArea(context) > 0 ? 34 : 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentIndex) {
      case 1:
        return '发布';
      case 2:
        return '我的';
      default:
        return '';
    }
  }

  Widget _buildReleaseTab() {
    return const Center(child: Text('发布页面内容', style: TextStyle(fontSize: 18)));
  }

  Widget _buildMineTab() {
    return const MyPage();
  }

  void _showReleaseSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ReleaseSelectionDialog(),
    );
  }

  void _showDrawerMenu() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const AppMenuDialog(),
    );
    
    if (result != null) {
      _handleMenuSelection(result);
    }
  }

  void _handleMenuSelection(String selection) {
    switch (selection) {
      case 'profile':
        // TODO: 导航到个人资料页面
        print('个人资料页面');
        break;
      case 'settings':
        // TODO: 导航到设置页面
        print('设置页面');
        break;
      case 'music':
        // TODO: 导航到我的音乐页面
        print('我的音乐页面');
        break;
      case 'help':
        // TODO: 导航到帮助页面
        print('帮助页面');
        break;
      case 'about':
        // TODO: 导航到关于我们页面
        print('关于我们页面');
        break;
    }
  }
}
