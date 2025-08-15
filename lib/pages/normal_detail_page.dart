import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../services/signup_service.dart';
import '../services/report_service.dart';
import '../services/activity_audio_service.dart';
import '../services/current_user_service.dart';
import '../services/signup_limit_service.dart';
import '../widgets/bouncing_music_note.dart';
import 'chat_detail_page.dart';

class NormalDetailPage extends StatefulWidget {
  final ActivityModel activity;

  const NormalDetailPage({super.key, required this.activity});

  @override
  State<NormalDetailPage> createState() => _NormalDetailPageState();
}

class _NormalDetailPageState extends State<NormalDetailPage> {
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
    print('NormalDetailPage: 设置音频，活动ID: ${widget.activity.id}');
    print('NormalDetailPage: 音频文件: ${widget.activity.audioFile}');
    
    // 检查是否有音频文件
    if (_audioService.hasAudioFile(widget.activity.audioFile)) {
      print('NormalDetailPage: 开始自动播放音频: ${widget.activity.audioFile}');
      // 自动播放音频
      _audioService.playAudio(widget.activity.audioFile!);
      
      // 监听播放状态
      _audioService.playingStateStream.listen((isPlaying) {
        print('NormalDetailPage: 播放状态变化: $isPlaying');
        if (mounted) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      });
    } else {
      print('NormalDetailPage: 没有音频文件或音频文件为空');
    }
  }

  Future<void> _checkSignUpStatus() async {
    final isSignedUp = await SignupService.isActivitySignedUp(widget.activity.id);
    setState(() {
      _isSignedUp = isSignedUp;
    });
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
    print('NormalDetailPage: 发布者头像信息:');
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
    print('NormalDetailPage: 发布者头像信息(带活动):');
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

  String _formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
              
              // 底部操作栏
              _buildBottomBar(),
            ],
          ),
          
          // 自定义导航栏
          _buildCustomAppBar(),
          
          // 跳动的音符（如果有音频文件）
          if (_audioService.hasAudioFile(widget.activity.audioFile))
            Positioned(
              right: 20,
              bottom: 100 + AppSizes.getBottomSafeArea(context),
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
      height: 500,
      width: double.infinity,
      child: Stack(
        children: [
          // 封面图片
          Image.asset(
            'assets/images/discoverAssets/${widget.activity.cover}',
            width: double.infinity,
            height: double.infinity,
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
          
          // 底部渐变
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ),
          
          // 活动标题
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Text(
              widget.activity.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活动详情
          Text(
            widget.activity.description,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 15,
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 50),
          
          // 发布者信息
          Row(
            children: [
              // 发布者头像
              widget.activity.publisherAvatar.isNotEmpty
                  ? ClipOval(
                      child: Image.asset(
                        'assets/images/discoverAssets/${widget.activity.publisherAvatar}',
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    )
                  : CircleAvatar(
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
              Expanded(
                child: Text(
                  widget.activity.publisherNickname,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 时间信息
          Row(
            children: [
              Image.asset(
                'assets/images/discoverAssets/icon_activity_time.webp',
                width: 16,
                height: 16,
                errorBuilder: (context, error, stack) {
                  return const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.primaryText,
                  );
                },
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _formatDateTime(widget.activity.eventTime),
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 地址信息
          Row(
            children: [
              Image.asset(
                'assets/images/discoverAssets/icon_activity_location.webp',
                width: 16,
                height: 16,
                errorBuilder: (context, error, stack) {
                  return const Icon(
                    Icons.location_on,
                    size: 16,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 100), // 为底部按钮留出空间
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 72 + AppSizes.getBottomSafeArea(context),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16, 
          8, 
          16, 
          AppSizes.getBottomSafeArea(context) + 8
        ),
        child: Row(
          children: [
            // 报名按钮 (1.5倍宽度)
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
            
            // 私聊按钮 (1倍宽度)
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
