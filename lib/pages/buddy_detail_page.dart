import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../constants/app_colors.dart';
import '../services/signup_service.dart';
import '../services/report_service.dart';
import '../services/activity_audio_service.dart';
import '../services/current_user_service.dart';
import '../services/signup_limit_service.dart';
import '../widgets/bouncing_music_note.dart';
import 'chat_detail_page.dart';

class BuddyDetailPage extends StatefulWidget {
  final ActivityModel activity;

  const BuddyDetailPage({super.key, required this.activity});

  @override
  State<BuddyDetailPage> createState() => _BuddyDetailPageState();
}

class _BuddyDetailPageState extends State<BuddyDetailPage> {
  bool _isSignedUp = false;
  bool _isPlaying = false;
  bool _wasPlayingBeforeChat = false;
  final ActivityAudioService _audioService = ActivityAudioService();

  @override
  void initState() {
    super.initState();
    _checkSignUpStatus();
    _setupAudio();
  }

  @override
  void dispose() {
    _audioService.stopAudio();
    super.dispose();
  }

  void _setupAudio() {
    print('BuddyDetailPage: 设置音频，活动ID: ${widget.activity.id}');
    print('BuddyDetailPage: 音频文件: ${widget.activity.audioFile}');
    
    // 检查是否有音频文件
    if (_audioService.hasAudioFile(widget.activity.audioFile)) {
      print('BuddyDetailPage: 开始自动播放音频: ${widget.activity.audioFile}');
      // 自动播放音频
      _audioService.playAudio(widget.activity.audioFile!);
      
      // 监听播放状态
      _audioService.playingStateStream.listen((isPlaying) {
        print('BuddyDetailPage: 播放状态变化: $isPlaying');
        if (mounted) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      });
    } else {
      print('BuddyDetailPage: 没有音频文件或音频文件为空');
    }
  }

  Future<void> _checkSignUpStatus() async {
    final isSignedUp = await SignupService.isActivitySignedUp(widget.activity.id);
    setState(() {
      _isSignedUp = isSignedUp;
    });
  }

  // 获取活动类型对应的图片
  String _getActivityTypeImage(String activityType) {
    const Map<String, String> typeImageMap = {
      '宠物': 'btn_release_friends_dw.webp',
      '电影': 'btn_release_friends_dy.webp',
      '干饭': 'btn_release_friends_gf.webp',
      '逛街': 'btn_release_friends_gj.webp',
      '喝酒': 'btn_release_friends_hj.webp',
      '户外': 'btn_release_friends_hw.webp',
      'K歌': 'btn_release_friends_kg.webp',
      '聊天': 'btn_release_friends_lt.webp',
      '旅游': 'btn_release_friends_ly.webp',
      '摄影': 'btn_release_friends_sy.webp',
      '学习': 'btn_release_friends_xx.webp',
      '运动': 'btn_release_friends_yd.webp',
      '游戏': 'btn_release_friends_yx.webp',
      '音乐': 'btn_release_friends_yy.webp',
      '追剧': 'btn_release_friends_zj.webp',
      '桌游': 'btn_release_friends_zy.webp',
    };
    
    return typeImageMap[activityType] ?? 'btn_release_friends_sy.webp';
  }

  void _onSignUpTap() async {
    if (_isSignedUp) {
      _showToast("您已经报名了活动，请耐心等待审核");
      return;
    }

    // 检查是否可以报名
    final canSignUp = await SignupLimitService.canSignUp();
    if (!canSignUp) {
      // 检查是否为VIP用户
      final isVipValid = await CurrentUserService.isVipValid();
      if (isVipValid) {
        _showToast("报名失败，请重试");
      } else {
        final remaining = await SignupLimitService.getRemainingSignups();
        _showToast("今日报名次数已用完，明天再来吧~");
      }
      return;
    }

    final success = await SignupService.signUpActivity(widget.activity.id);
    if (success) {
      setState(() {
        _isSignedUp = true;
      });
      _showToast("您已经报名了活动，请耐心等待审核");
    } else {
      _showToast("报名失败，请重试");
    }
  }

  void _onChatTap() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final isValid = widget.activity.eventTime > now;
    
    if (!isValid) {
      // 活动已过期，直接进入私聊
      _navigateToChat();
    } else {
      // 活动有效期内，检查是否已报名或是否为VIP会员
      if (!_isSignedUp) {
        // 检查是否为VIP会员
        final isVipValid = await CurrentUserService.isVipValid();
        if (isVipValid) {
          // VIP会员可以直接进入私聊
          _navigateToChatWithActivity();
        } else {
          _showToast("先报名后才能和TA聊天哦~");
        }
      } else {
        _navigateToChatWithActivity();
      }
    }
  }

  void _navigateToChat() {
    // 记录当前播放状态
    _wasPlayingBeforeChat = _isPlaying;
    
    // 暂停音频
    if (_isPlaying) {
      _audioService.pauseAudio();
    }
    
    // 调试打印发布者头像信息
    print('BuddyDetailPage: 发布者头像信息:');
    print('  - publisherAvatar: ${widget.activity.publisherAvatar}');
    print('  - 完整路径: assets/images/discoverAssets/${widget.activity.publisherAvatar}');
    print('  - publisherId: ${widget.activity.publisherId}');
    print('  - publisherNickname: ${widget.activity.publisherNickname}');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          userId: widget.activity.publisherId,
          userNickname: widget.activity.publisherNickname,
          userAvatar: 'assets/images/discoverAssets/${widget.activity.publisherAvatar}',
          userGender: widget.activity.publisherGender,
          userPersonalityTag: widget.activity.personalityTag,
        ),
      ),
    ).then((_) {
      // 从私信页面返回后，如果之前在播放，继续播放
      if (_wasPlayingBeforeChat && _audioService.hasAudioFile(widget.activity.audioFile)) {
        _audioService.resumeAudio();
      }
    });
  }

  void _navigateToChatWithActivity() {
    // 记录当前播放状态
    _wasPlayingBeforeChat = _isPlaying;
    
    // 暂停音频
    if (_isPlaying) {
      _audioService.pauseAudio();
    }
    
    // 调试打印发布者头像信息
    print('BuddyDetailPage: 发布者头像信息(带活动):');
    print('  - publisherAvatar: ${widget.activity.publisherAvatar}');
    print('  - 完整路径: assets/images/discoverAssets/${widget.activity.publisherAvatar}');
    print('  - publisherId: ${widget.activity.publisherId}');
    print('  - publisherNickname: ${widget.activity.publisherNickname}');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          userId: widget.activity.publisherId,
          userNickname: widget.activity.publisherNickname,
          userAvatar: 'assets/images/discoverAssets/${widget.activity.publisherAvatar}',
          userGender: widget.activity.publisherGender,
          userPersonalityTag: widget.activity.personalityTag,
        ),
      ),
    ).then((_) {
      // 从私信页面返回后，如果之前在播放，继续播放
      if (_wasPlayingBeforeChat && _audioService.hasAudioFile(widget.activity.audioFile)) {
        _audioService.resumeAudio();
      }
    });
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ReportDialog(
        onSubmit: (reason) => _submitReport(reason),
        onCancel: () => Navigator.pop(context),
      ),
    );
  }


  
  void _submitReport(String reason) async {
    // 缓存举报信息
    await _saveReportRecord(reason);
    Navigator.pop(context);
    _showToast("举报已提交: $reason");
  }
  
  Future<void> _saveReportRecord(String reason) async {
    final report = ReportRecord(
      id: 'report_${DateTime.now().millisecondsSinceEpoch}',
      targetUserId: widget.activity.publisherId,
      targetName: widget.activity.publisherNickname,
      reportType: reason,
      content: '举报活动: ${widget.activity.title}，原因: $reason',
      reportTime: DateTime.now(),
      status: ReportStatus.pending,
    );
    
    await ReportService.saveReport(report);
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 主内容
          Column(
            children: [
              // 头部封面区域
              _buildHeader(),
              
              // 信息区域
              Expanded(
                child: SingleChildScrollView(
                  child: _buildContent(),
                ),
              ),
            ],
          ),
          
          // 自定义导航栏
          _buildCustomAppBar(),
          
          // 跳动的音符（如果有音频文件）
          if (_audioService.hasAudioFile(widget.activity.audioFile))
            Positioned(
              right: 20,
              bottom: 100,
              child: BouncingMusicNote(
                isPlaying: _isPlaying,
                onTap: () {
                  if (_isPlaying) {
                    _audioService.pauseAudio();
                  } else {
                    _audioService.resumeAudio();
                  }
                },
                size: 60,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).padding.top + 56,
        child: Stack(
          children: [
            // 渐变阴影背景
            Image.asset(
              'assets/images/msgAssets/img_chat_shadow.webp',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                );
              },
            ),
            
            // 导航按钮
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              height: 56,
              child: Row(
                children: [
                  // 返回按钮
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/pubAssets/btn_back.webp',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stack) {
                          return const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 举报按钮
                  GestureDetector(
                    onTap: _showReportDialog,
                    child: Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/discoverAssets/btn_homepage_report.webp',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stack) {
                          return const Icon(
                            Icons.report_outlined,
                            color: Colors.white,
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 400,
      width: double.infinity,
      child: Image.asset(
        'assets/images/discoverAssets/${widget.activity.cover}',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) {
          return Container(
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.image_not_supported,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活动标题和性格标签
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.activity.title,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primaryTextHighlight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.activity.personalityTag,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 用户性别+地址
          Text(
            '${widget.activity.publisherGender} · ${widget.activity.location}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 活动类型标题
          const Text(
            '搭子类型',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 活动内容展示容器
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBFE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 活动要求 - 左对齐
                Text(
                  widget.activity.requirements.isEmpty 
                      ? '不限条件' 
                      : widget.activity.requirements,
                  style: TextStyle(
                    color: AppColors.primaryText.withValues(alpha: 0.4),
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 活动类型和内容区域
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 活动类型图片
                    Image.asset(
                      'assets/images/pubAssets/${_getActivityTypeImage(widget.activity.activityType)}',
                      width: 75,
                      height: 91,
                      errorBuilder: (context, error, stack) {
                        return Container(
                          width: 75,
                          height: 91,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // 右侧内容区域
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 活动内容
                          Text(
                            widget.activity.description,
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // 地址信息 - 左对齐
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/discoverAssets/icon_homepage_location.webp',
                                width: 18,
                                height: 18,
                                errorBuilder: (context, error, stack) {
                                  return const Icon(
                                    Icons.location_on,
                                    size: 18,
                                    color: AppColors.primaryText,
                                  );
                                },
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.activity.location,
                                  style: const TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 报名人数
          Text(
            '已报名 ${widget.activity.registeredCount} 人',
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 底部按钮
          Row(
            children: [
              // 报名按钮
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: _onSignUpTap,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isSignedUp 
                          ? const Color(0xFFCEF600).withValues(alpha: 0.4)
                          : const Color(0xFFCEF600),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _isSignedUp ? '已报名' : '报名',
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // 私聊按钮
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: _onChatTap,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF538),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '私聊',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ReportDialog extends StatefulWidget {
  final Function(String) onSubmit;
  final VoidCallback onCancel;

  const _ReportDialog({
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  String _selectedReportReason = '';

  List<Widget> _buildReportOptions() {
    final reasons = [
      '虚假信息',
      '不当内容',
      '涉嫌诈骗',
      '色情违法',
      '垃圾广告',
      '恶意骚扰',
      '其他原因',
    ];
    
    return reasons.map((reason) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedReportReason = reason;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _selectedReportReason == reason 
                  ? const Color(0xFFCEF600) 
                  : AppColors.primaryText.withValues(alpha: 0.2),
              width: 1.5,
            ),
            color: _selectedReportReason == reason 
                ? const Color(0xFFCEF600).withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                _selectedReportReason == reason 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
                color: _selectedReportReason == reason 
                    ? const Color(0xFFCEF600) 
                    : AppColors.primaryText.withValues(alpha: 0.4),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                reason,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _selectedReportReason == reason 
                      ? AppColors.primaryText 
                      : AppColors.primaryText.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            const Text(
              '举报原因',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请选择举报原因，我们会认真处理',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryText.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            
            // 举报选项
            ..._buildReportOptions(),
            
            const SizedBox(height: 24),
            
            // 按钮
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: widget.onCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.primaryText, width: 1),
                      ),
                    ),
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedReportReason.isNotEmpty 
                        ? () => widget.onSubmit(_selectedReportReason)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCEF600),
                      foregroundColor: AppColors.primaryText,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '提交',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
