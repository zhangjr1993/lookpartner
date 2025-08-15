import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/user_info_service.dart';
import '../services/mbti_service.dart';
import '../services/keychain_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nicknameController = TextEditingController();
  String? _selectedAge;
  String? _selectedMbti;
  String? _avatarPath;
  bool _isFormValid = false;

  // MBTI标签列表
  final List<String> _mbtiTypes = [
    'INTP', 'INTJ', 'ENTP', 'ENTJ', 'ENFJ',
    'INFJ', 'INFP', 'ENFP', 'ESFP', 'ISFP',
    'ISTP', 'ESTP', 'ISFJ', 'ISTJ', 'ESFJ', 'ESTJ'
  ];

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_validateForm);
    _loadCurrentUserInfo();
  }

  Future<void> _loadCurrentUserInfo() async {
    // 从KeychainService加载当前用户信息
    final user = await KeychainService.getUser();
    if (user != null) {
      setState(() {
        _nicknameController.text = user.nickname;
        _selectedAge = user.age.toString();
        _selectedMbti = user.personalityType;
        // 注意：这里不设置_avatarPath，因为Keychain中的是webp路径，不是本地文件路径
      });
    }
    
    _validateForm();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _nicknameController.text.isNotEmpty && 
                     _selectedAge != null && 
                     _selectedMbti != null;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _avatarPath = image.path;
      });
    }
  }

  void _showAgePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消', style: TextStyle(color: Color(0xFF666666))),
                    ),
                    const Text(
                      '选择年龄',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF171717),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _validateForm();
                      },
                      child: const Text('确定', style: TextStyle(color: Color(0xFF171717))),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListWheelScrollView(
                  itemExtent: 50,
                  children: List.generate(83, (index) {
                    final age = index + 18;
                    return Center(
                      child: Text(
                        '$age岁',
                        style: TextStyle(
                          fontSize: 18,
                          color: _selectedAge == '$age岁' 
                              ? const Color(0xFF171717) 
                              : const Color(0xFF666666),
                          fontWeight: _selectedAge == '$age岁' 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  }),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedAge = '${index + 18}岁';
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF171717)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '编辑资料',
          style: TextStyle(
            color: Color(0xFF171717),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像上传区域
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: _avatarPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: Image.file(
                                File(_avatarPath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) {
                                  return const Icon(
                                    Icons.add,
                                    color: Color(0xFFB8BCC4),
                                    size: 40,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.add,
                              color: Color(0xFFB8BCC4),
                              size: 40,
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '请上传头像',
                    style: TextStyle(
                      color: Color(0xFFB8BCC4),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 昵称输入区域
            const Text(
              '昵称',
              style: TextStyle(
                color: Color(0xFF171717),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                hintText: '希望别人怎么称呼你',
                hintStyle: TextStyle(
                  color: Color(0xFFB8BCC4),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCEF600)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(
                color: Color(0xFF171717),
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 年龄选择区域
            const Text(
              '年龄',
              style: TextStyle(
                color: Color(0xFF171717),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showAgePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedAge ?? '选择你的年龄',
                        style: TextStyle(
                          color: _selectedAge != null 
                              ? const Color(0xFF171717) 
                              : const Color(0xFFB8BCC4),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFFB8BCC4),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // MBTI选择区域
            const Text(
              '你的MBTI',
              style: TextStyle(
                color: Color(0xFF171717),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // MBTI标签网格
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _mbtiTypes.map((mbti) {
                final isSelected = _selectedMbti == mbti;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMbti = mbti;
                      _validateForm();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFCEF600) : Colors.white,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFCEF600) : const Color(0xFFE0E0E0),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      mbti,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF171717) : const Color(0xFF171717),
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFF0F0F0), width: 1),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isFormValid ? _saveProfile : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid 
                  ? const Color(0xFFCEF600) 
                  : const Color(0xFFB8BCC4),
              foregroundColor: _isFormValid 
                  ? const Color(0xFF171717) 
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              '保存',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    try {
      // 获取当前用户信息
      final currentUser = await KeychainService.getUser();
      if (currentUser == null) {
        throw Exception('无法获取当前用户信息');
      }
      
      // 创建更新后的用户信息
      final updatedUser = currentUser.copyWith(
        nickname: _nicknameController.text.trim(),
        age: _selectedAge != null ? int.parse(_selectedAge!) : currentUser.age,
        customAvatarPath: _avatarPath, // 使用自定义头像路径
        personalityType: _selectedMbti ?? currentUser.personalityType,
      );
      
      // 保存到Keychain
      await KeychainService.updateUser(updatedUser);
      print('EditProfile: 已更新Keychain中的用户信息');
      
      // 同时保存到UserInfoService (为了兼容性)
      await UserInfoService.updateUserName(_nicknameController.text.trim());
      if (_selectedAge != null) {
        await UserInfoService.updateUserAge(int.parse(_selectedAge!));
      }
      if (_avatarPath != null) {
        final isNewUpload = _avatarPath != await UserInfoService.getUserAvatar();
        await UserInfoService.updateUserAvatar(_avatarPath!, isNewUpload: isNewUpload);
      }
      
      // 保存MBTI信息
      if (_selectedMbti != null) {
        await MbtiService.savePersonalityResult(_selectedMbti!);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('资料保存成功！'),
          backgroundColor: Color(0xFFCEF600),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true); // 返回true表示有更新
    } catch (e) {
      print('保存用户信息失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存失败，请重试'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
