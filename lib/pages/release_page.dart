import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/activity.dart';
import '../widgets/activity_type_dialog.dart';
import '../widgets/image_picker_dialog.dart';
import '../services/native_permission_service.dart';
import '../services/draft_service.dart';
import '../services/published_cache_service.dart';

enum ReleaseType { buddy, activity }

class ReleasePage extends StatefulWidget {
  final ReleaseType releaseType;

  const ReleasePage({
    super.key,
    required this.releaseType,
  });

  @override
  State<ReleasePage> createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  DateTime? _selectedDateTime;
  String? _coverImagePath;
  String? _selectedActivityType;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // 加载草稿
  Future<void> _loadDraft() async {
    final draft = await DraftService.loadDraft();
    if (draft != null && draft.releaseType == widget.releaseType) {
      setState(() {
        _titleController.text = draft.title;
        _descriptionController.text = draft.description;
        _locationController.text = draft.location;
        _selectedDateTime = draft.selectedDateTime;
        _coverImagePath = draft.coverImagePath;
        _selectedActivityType = draft.selectedActivityType;
      });
    }
  }

  void _showDateTimePicker() {
    final now = DateTime.now();
    final currentYear = now.year;
    
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(currentYear),
      lastDate: DateTime(currentYear + 10),
      cancelText: '取消', // Cancel改为"取消"
      confirmText: '确定', // OK改为"确定"
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF171717), // 活动时间弹窗的cancel和ok按钮颜色改为色号#171717
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF171717), // 按钮文字颜色
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          cancelText: '取消', // Cancel改为"取消"
          confirmText: '确定', // OK改为"确定"
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: const Color(0xFF171717), // 活动时间弹窗的cancel和ok按钮颜色改为色号#171717
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF171717), // 按钮文字颜色
                  ),
                ),
              ),
              child: child!,
            );
          },
        ).then((time) {
          if (time != null) {
            setState(() {
              _selectedDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          }
        });
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _uploadCover() {
    if (widget.releaseType == ReleaseType.buddy) {
      // 如果是搭子活动：点击展示本地弹窗活动类型
      _showActivityTypeDialog();
    } else {
      // 如果是普通活动：展示选择相机、相册、取消按钮弹窗
      _showImagePickerDialog();
    }
  }

  void _showActivityTypeDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ActivityTypeDialog(
        onTypeSelected: (type) {
          setState(() {
            _selectedActivityType = type;
          });
        },
      ),
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ImagePickerDialog(
        onCameraTap: _pickImageFromCamera,
        onGalleryTap: _pickImageFromGallery,
        onCancelTap: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    Navigator.pop(context);
    
    // 使用原生权限服务主动触发iOS系统权限弹窗
    final granted = await NativePermissionService.requestCameraPermission();
    
    if (granted) {
      _launchCamera();
    } else {
      // 权限被拒绝，引导用户到设置
      _showPermissionDialog('相机', '拍摄封面图片');
    }
  }
  
  Future<void> _launchCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _coverImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('相机拍照失败: $e')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    Navigator.pop(context);
    
    // 使用原生权限服务主动触发iOS系统权限弹窗
    final granted = await NativePermissionService.requestPhotoPermission();
    
    if (granted) {
      _launchGallery();
    } else {
      // 权限被拒绝，引导用户到设置
      _showPermissionDialog('相册', '选择封面图片');
    }
  }
  
  Future<void> _launchGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _coverImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('相册选择失败: $e')),
      );
    }
  }

  // 权限弹窗
  void _showPermissionDialog(String permissionType, String purpose) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('需要$permissionType权限'),
          content: Text('为了$purpose，需要您授予$permissionType权限。请到设置中开启权限。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('去设置'),
            ),
          ],
        );
      },
    );
  }

  // 关闭按钮处理
  void _onClosePressed() {
    final currentDraft = DraftData(
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      selectedDateTime: _selectedDateTime,
      coverImagePath: _coverImagePath,
      selectedActivityType: _selectedActivityType,
      releaseType: widget.releaseType,
    );

    if (DraftService.isDraftNotEmpty(currentDraft)) {
      _showDraftDialog();
    } else {
      Navigator.pop(context);
    }
  }

  // 显示草稿保存对话框
  void _showDraftDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('保存草稿'),
          content: const Text('已编辑的内容是否保存到草稿？'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await DraftService.deleteDraft();
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _saveDraft();
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  // 保存草稿
  Future<void> _saveDraft() async {
    final draftData = DraftData(
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      selectedDateTime: _selectedDateTime,
      coverImagePath: _coverImagePath,
      selectedActivityType: _selectedActivityType,
      releaseType: widget.releaseType,
    );
    
    await DraftService.saveDraft(draftData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('草稿已保存')),
    );
  }

  Future<void> _submitRelease() async {
    if (widget.releaseType == ReleaseType.buddy) {
      // 搭子活动验证
      if (_selectedActivityType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请选择搭子类型')),
        );
        return;
      }
    } else {
      // 普通活动验证
      if (_coverImagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请上传封面图片')),
        );
        return;
      }
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写活动标题')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写活动简介')),
      );
      return;
    }

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择活动时间')),
      );
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写活动地点')),
      );
      return;
    }

    // 发布成功后，保存到发布缓存，删除草稿并退出页面
    await PublishedCacheService.savePublishedActivity(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      eventTime: _selectedDateTime!,
      coverImagePath: _coverImagePath,
      selectedActivityType: _selectedActivityType,
      releaseType: widget.releaseType,
    );
    
    DraftService.deleteDraft();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('发布成功，等待审核')),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primaryText),
          onPressed: _onClosePressed,
        ),
        title: const Text(
          '发布活动',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 第1个区间：上传封面
            _buildSection(
              title: '上传封面',
              child: Center(
                child: GestureDetector(
                  onTap: _uploadCover,
                  child: Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: widget.releaseType == ReleaseType.buddy
                        ? _buildBuddyCover()
                        : _buildActivityCover(),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 第2个区间：活动场次
            _buildSection(
              title: '活动场次',
              child: TextField(
                controller: _titleController,
                maxLength: 30,
                decoration: const InputDecoration(
                  hintText: '填写活动标题',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 第3个区间：活动简介
            _buildSection(
              title: '活动简介',
              child: TextField(
                controller: _descriptionController,
                maxLength: 1000,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: '输入活动简介',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 第4个区间：选择活动时间
            _buildSection(
              title: '选择活动时间',
              child: GestureDetector(
                onTap: _showDateTimePicker,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDateTime != null
                              ? _formatDateTime(_selectedDateTime!)
                              : '选择活动时间',
                          style: TextStyle(
                            color: _selectedDateTime != null
                                ? AppColors.primaryText
                                : Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 第5个区间：选择活动地点
            _buildSection(
              title: '选择活动地点',
              child: TextField(
                controller: _locationController,
                maxLength: 10, // 输入框限制10字以内
                decoration: const InputDecoration(
                  hintText: '填写活动的地点',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 发布按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRelease,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTextHighlight,
                  foregroundColor: AppColors.primaryText,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '发布活动',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  // 搭子活动封面
  Widget _buildBuddyCover() {
    if (_selectedActivityType != null) {
      // 根据选择的搭子类型显示对应的图片
      final imagePath = _getBuddyTypeImagePath(_selectedActivityType!);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 32,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '已选择搭子类型',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
      // 未选择搭子类型时显示提示
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 32,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            '选择搭子类型',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      );
    }
  }

  // 普通活动封面
  Widget _buildActivityCover() {
    if (_coverImagePath != null) {
      // 显示选择的图片，固定宽高120x160
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(_coverImagePath!),
          width: 120,
          height: 160,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // 未选择图片时显示提示
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 32,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            '上传封面',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      );
    }
  }

  // 根据搭子类型获取对应的图片路径
  String _getBuddyTypeImagePath(String type) {
    final imageMap = {
      '宠物': 'assets/images/pubAssets/btn_release_friends_dw.webp',
      '电影': 'assets/images/pubAssets/btn_release_friends_dy.webp',
      '干饭': 'assets/images/pubAssets/btn_release_friends_gf.webp',
      '逛街': 'assets/images/pubAssets/btn_release_friends_gj.webp',
      '喝酒': 'assets/images/pubAssets/btn_release_friends_hj.webp',
      '户外': 'assets/images/pubAssets/btn_release_friends_hw.webp',
      'K歌': 'assets/images/pubAssets/btn_release_friends_kg.webp',
      '聊天': 'assets/images/pubAssets/btn_release_friends_lt.webp',
      '旅游': 'assets/images/pubAssets/btn_release_friends_ly.webp',
      '摄影': 'assets/images/pubAssets/btn_release_friends_sy.webp',
      '学习': 'assets/images/pubAssets/btn_release_friends_xx.webp',
      '运动': 'assets/images/pubAssets/btn_release_friends_yd.webp',
      '游戏': 'assets/images/pubAssets/btn_release_friends_yx.webp',
      '音乐': 'assets/images/pubAssets/btn_release_friends_yy.webp',
      '追剧': 'assets/images/pubAssets/btn_release_friends_zj.webp',
      '桌游': 'assets/images/pubAssets/btn_release_friends_zy.webp',
    };
    return imageMap[type] ?? 'assets/images/pubAssets/btn_release_friends_dw.webp';
  }
}
