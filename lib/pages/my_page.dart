import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/activity.dart';
import '../services/mbti_service.dart';
import '../services/published_cache_service.dart';
import '../services/diamond_service.dart';
import '../services/keychain_service.dart';
import '../services/current_user_service.dart';
import 'edit_profile_page.dart';
import 'vip_membership_page.dart';
import 'discover_page.dart';
import 'my_activities_page.dart';
import 'my_music_page.dart';
import 'draft_page.dart';
import 'message_list_page.dart';
import 'report_history_page.dart';
import 'blacklist_page.dart';
import 'mbti_test_page.dart';
import 'feedback_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<ActivityModel> _myActivities = [];
  String? _personalityTag;
  int _diamondBalance = 0;
  String _userName = "寒寒";
  String _userGenderLocation = "24岁 / 火星";
  String _userAvatar = "";
  String _avatarStatus = "normal";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 只加载发布缓存的活动，不显示草稿
      final publishedActivities = await PublishedCacheService.getPublishedActivities();
      _myActivities = publishedActivities;

      // 加载性格标签
      final personalityResult = await MbtiService.getPersonalityResult();
      if (personalityResult != null) {
        _personalityTag = personalityResult;
      } else {
        // 如果没有保存的性格标签，设置一个默认值
        _personalityTag = 'ENFP';
      }
      
      // 加载用户信息
      final user = await KeychainService.getUser();
      if (user != null) {
        _userName = user.nickname;
        _userGenderLocation = '${user.age}岁 / ${user.city}';
        // 优先使用自定义头像，如果没有则使用默认头像
        if (user.customAvatarPath != null && user.customAvatarPath!.isNotEmpty) {
          _userAvatar = user.customAvatarPath!;
        } else {
          _userAvatar = user.avatar.isNotEmpty ? 'assets/images/${user.avatar}' : '';
        }
        _avatarStatus = 'normal'; // 暂时设为normal，后续可以扩展
        
        print('MyPage: 加载用户信息:');
        print('  - 昵称: ${user.nickname}');
        print('  - 头像路径: $_userAvatar');
        print('  - 年龄城市: $_userGenderLocation');
      }
      
      // 加载钻石余额
      _diamondBalance = await DiamondService.getDiamondBalance();
    } catch (e) {
      print('加载我的页面数据失败: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeaderSection(),
                _buildVipSection(),
                _buildMyPublishedSection(),
              ],
            ),
    );
  }

  // 头部渐变区域
  Widget _buildHeaderSection() {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9D6B7B), Color(0xFF7B889F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // 顶部按钮区域 - 使用Row布局确保正确的间距
          Positioned(
            top: MediaQuery.of(context).padding.top + 12, // 状态栏下方+12
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 钻石容器 - 宽度跟随内容，高度固定24
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          'assets/images/mineAssets/icon_me_coin.webp',
                          width: 22,
                          height: 22,
                          errorBuilder: (context, error, stack) {
                            return const Icon(
                              Icons.diamond,
                              color: Color(0xFF171717),
                              size: 22,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          _diamondBalance.toString(),
                          style: const TextStyle(
                            color: Color(0xFF171717),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16), // 钻石容器与编辑按钮间距
                
                // 编辑按钮 - 24x24
                GestureDetector(
                  onTap: _onEditTap,
                  child: Image.asset(
                    'assets/images/mineAssets/btn_me_edit.webp',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stack) {
                      return const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 24,
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 16), // 编辑按钮与设置按钮间距
                
                // 设置按钮 - 24x24
                GestureDetector(
                  onTap: _onSettingTap,
                  child: Image.asset(
                    'assets/images/mineAssets/btn_me_setting.webp',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stack) {
                      return const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 24,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // 用户头像
          Positioned(
            left: 16,
            bottom: 12,
            child: Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: _userAvatar.isNotEmpty
                        ? Image.asset(
                            _userAvatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                  ),
                ),
                // 审核中标签
                if (_avatarStatus == 'pending')
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '审核中',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // 用户昵称和性格标签
          Positioned(
            left: 92, // 16 + 64 + 12
            bottom: 44, // 12 + 20 + 12
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                  ),
                ),
                if (_personalityTag != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    height: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF538),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _personalityTag!,
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // 性别+地址
          Positioned(
            left: 92, // 16 + 64 + 12
            bottom: 20, // 12 + 8
            child: Text(
              _userGenderLocation,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 会员区域
  Widget _buildVipSection() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: GestureDetector(
          onTap: _onVipTap,
          child: FutureBuilder<bool>(
            future: CurrentUserService.isVipValid(),
            builder: (context, snapshot) {
              final isVipValid = snapshot.data ?? false;
              
              if (isVipValid) {
                // VIP会员显示特殊背景和有效期
                return _buildVipMemberDisplay();
              } else {
                // 非VIP显示普通背景
                return Image.asset(
                  'assets/images/mineAssets/img_me_vip.webp',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stack) {
                    return _buildDefaultVipDisplay();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // VIP会员显示
  Widget _buildVipMemberDisplay() {
    return FutureBuilder<DateTime?>(
      future: CurrentUserService.getVipExpireTime(),
      builder: (context, snapshot) {
        final expireTime = snapshot.data;
        String expireText = 'VIP会员';
        
        if (expireTime != null) {
          final year = expireTime.year;
          final month = expireTime.month.toString().padLeft(2, '0');
          final day = expireTime.day.toString().padLeft(2, '0');
          expireText = '有效期到 $year年$month月$day日';
        }
        
        return Container(
          height: 120,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mineAssets/img_me_vip_time.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'VIP会员',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        expireText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '续费 >',
                    style: TextStyle(
                      color: Color(0xFF8B4513),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 默认VIP显示
  Widget _buildDefaultVipDisplay() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.verified,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '会员',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '解锁更多特权',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                '去开通 >',
                style: TextStyle(
                  color: Color(0xFF8B4513),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 我发布的区域 - 直接显示，不需要标签页
  Widget _buildMyPublishedSection() {
    return Expanded(
      child: Column(
        children: [
          // 标题区域
          Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Row(
              children: [
                                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(
                     color: Colors.transparent,
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: const Text(
                     '我发布的',
                     style: TextStyle(
                       color: Color(0xFF171717),
                       fontSize: 16,
                       fontWeight: FontWeight.w500,
                     ),
                   ),
                 ),
              ],
            ),
          ),
          
          // 活动列表
          Expanded(
            child: _myActivities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: _myActivities.length,
                    itemBuilder: (context, index) => _buildActivityItem(_myActivities[index], index),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityModel activity, int index) {
    final isEven = index % 2 == 0;
    final backgroundColor = isEven ? const Color(0xFFF8FBFE) : const Color(0xFFFCFFF1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 活动封面
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/discoverAssets/${activity.cover}',
                      width: 96,
                      height: 127,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return Container(
                          width: 96,
                          height: 127,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                  // 审核标签或草稿标签
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: activity.isDraft ? const Color(0xFFFF6B6B) : const Color(0xFFFFF538),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          activity.isDraft ? '草稿' : '审核中',
                          style: const TextStyle(
                            color: Color(0xFF171717),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 10),
              
              // 右侧内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 活动标题
                    Text(
                      activity.title,
                      style: const TextStyle(
                        color: Color(0xFF171717),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 活动时间
                    Text(
                      _formatTime(activity.eventTime),
                      style: TextStyle(
                        color: const Color(0xFF171717).withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 活动地址
                    Text(
                      activity.location,
                      style: TextStyle(
                        color: const Color(0xFF171717).withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 已报名人数
                    Text(
                      '已报名 ${activity.joinedPeople}/${activity.maxPeople}人',
                      style: TextStyle(
                        color: const Color(0xFF171717).withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 空状态组件
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 空状态图标
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.event_note_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 空状态文案
          Text(
            '暂无发布内容',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '快去发布你的第一个活动吧',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _onEditTap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
    
    // 从编辑页面返回后，重新加载用户信息
    await _loadData();
  }

  void _onSettingTap() async {
    // 获取用户信息
    final user = await KeychainService.getUser();
    final userName = user?.nickname;
    // 优先使用自定义头像，如果没有则使用默认头像
    String? userAvatar;
    if (user != null) {
      if (user.customAvatarPath != null && user.customAvatarPath!.isNotEmpty) {
        userAvatar = user.customAvatarPath!;
      } else if (user.avatar.isNotEmpty) {
        userAvatar = 'assets/images/${user.avatar}';
      }
    }
    
    // 使用与首页发现页面完全相同的侧滑菜单
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return SidebarMenuWidget(
          userId: user?.userId ?? '12345678',
          userAvatar: userAvatar,
          userName: userName,
          onMenuItemTap: (title) {
            // 处理菜单项点击
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
          },
          onBottomMenuTap: (title) {
            // 处理底部菜单点击
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
          },
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

  void _onVipTap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VipMembershipPage()),
    );
    
    // 从VIP页面返回后，重新加载数据
    await _loadData();
  }

  // 格式化时间显示
  String _formatTime(int timestamp) {
    final now = DateTime.now();
    final eventTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final difference = eventTime.difference(now);
    
    if (difference.inDays == 0) {
      return '今天 ${eventTime.hour.toString().padLeft(2, '0')}:${eventTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '明天 ${eventTime.hour.toString().padLeft(2, '0')}:${eventTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${eventTime.month}/${eventTime.day} ${eventTime.hour.toString().padLeft(2, '0')}:${eventTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

