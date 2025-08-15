import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../services/signup_service.dart';
import '../services/activity_service.dart';
import 'buddy_detail_page.dart';
import 'normal_detail_page.dart';

class MyActivitiesPage extends StatefulWidget {
  const MyActivitiesPage({super.key});

  @override
  State<MyActivitiesPage> createState() => _MyActivitiesPageState();
}

class _MyActivitiesPageState extends State<MyActivitiesPage> {
  List<ActivityModel> _myActivities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyActivities();
  }

  Future<void> _loadMyActivities() async {
    try {
      // 获取我报名的活动ID列表
      final signedUpIds = await SignupService.getSignedUpActivities();
      
      // 获取所有活动
      final allActivities = await ActivityService.readAllFromLocal();
      
      // 筛选出我报名的活动
      final myActivities = allActivities.where((activity) => 
        signedUpIds.contains(activity.id)
      ).toList();
      
      setState(() {
        _myActivities = myActivities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _onActivityTap(ActivityModel activity) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '我的活动',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 背景渐变图
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/discoverAssets/bg_home_shadow.webp',
              width: double.infinity,
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
          
          // 主内容
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _myActivities.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '还没有报名任何活动',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _myActivities.length,
                      itemBuilder: (context, index) {
                        return _buildActivityItem(_myActivities[index], index);
                      },
                    ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityModel activity, int index) {
    // 奇数偶数背景色
    final backgroundColor = index % 2 == 0 
        ? const Color(0xFFF8FBFE) 
        : const Color(0xFFFCFFF1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _onActivityTap(activity),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // 主要内容区域
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 活动封面
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/discoverAssets/${activity.cover}',
                      width: double.infinity,
                      height: 127,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return Container(
                          width: double.infinity,
                          height: 127,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 活动标题
                  Text(
                    activity.title,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 活动时间
                  Text(
                    _formatDateTime(activity.eventTime),
                    style: TextStyle(
                      color: AppColors.primaryText.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 活动地址
                  Text(
                    activity.location,
                    style: TextStyle(
                      color: AppColors.primaryText.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 已报名人数
                  Text(
                    '已报名 ${activity.registeredCount} 人',
                    style: TextStyle(
                      color: AppColors.primaryText.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 发布者信息
                  Row(
                    children: [
                      // 发布者头像
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // 发布者昵称
                      Text(
                        activity.publisherNickname,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // 发布者头像 - 重新定位到左侧，封面下方16px
              Positioned(
                left: 12,
                top: 127 + 16, // 封面高度 + 16px间距
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(
                      Icons.person,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
