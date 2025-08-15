import 'dart:math';
import '../models/user_model.dart';

class UserGenerator {
  static final Random _random = Random();
  
  // 默认头像列表
  static const List<String> _defaultAvatars = [
    'discoverAssets/user_01.webp',
    'discoverAssets/user_02.webp',
    'discoverAssets/user_03.webp',
    'discoverAssets/user_04.webp',
    'discoverAssets/user_05.webp',
    'discoverAssets/user_06.webp',
  ];
  
  // 城市列表
  static const List<String> _cities = [
    '北京', '上海', '广州', '深圳', '杭州', '南京', '成都', '武汉', '西安', '重庆',
    '苏州', '天津', '长沙', '青岛', '无锡', '宁波', '郑州', '佛山', '东莞', '合肥'
  ];
  
  // MBTI性格类型
  static const List<String> _mbtiTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP',
    'INFJ', 'INFP', 'ENFJ', 'ENFP',
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
    'ISTP', 'ISFP', 'ESTP', 'ESFP'
  ];
  
  // 姓氏列表
  static const List<String> _surnames = [
    '张', '王', '李', '赵', '陈', '刘', '杨', '黄', '周', '吴',
    '徐', '孙', '胡', '朱', '高', '林', '何', '郭', '马', '罗'
  ];
  
  // 名字常用字
  static const List<String> _nameChars = [
    '伟', '芳', '娜', '敏', '静', '丽', '强', '磊', '军', '洋',
    '勇', '艳', '杰', '娟', '涛', '明', '超', '秀', '霞', '平'
  ];

  static User generateRandomUser() {
    return User(
      nickname: _generateNickname(),
      userId: _generateUserId(),
      avatar: _generateAvatar(),
      customAvatarPath: null, // 初始没有自定义头像
      diamonds: _generateDiamonds(),
      isVip: false,
      vipExpireTime: null,
      gender: _generateGender(),
      age: _generateAge(),
      city: _generateCity(),
      personalityType: _generateMBTI(),
      registeredActivities: [],
      messages: [],
    );
  }

  static String _generateNickname() {
    final surname = _surnames[_random.nextInt(_surnames.length)];
    final nameChar = _nameChars[_random.nextInt(_nameChars.length)];
    final randomNumber = _random.nextInt(9000) + 1000; // 4位随机数
    return '$surname$nameChar$randomNumber';
  }

  static String _generateUserId() {
    return (_random.nextInt(90000000) + 10000000).toString(); // 8位随机数
  }

  static String _generateAvatar() {
    return _defaultAvatars[_random.nextInt(_defaultAvatars.length)];
  }

  static int _generateDiamonds() {
    return 200; // 固定200钻石
  }

  static String _generateGender() {
    return _random.nextBool() ? '男' : '女';
  }

  static int _generateAge() {
    return _random.nextInt(22) + 18; // 18-39岁
  }

  static String _generateCity() {
    return '火星'; // 固定火星
  }

  static String _generateMBTI() {
    return _mbtiTypes[_random.nextInt(_mbtiTypes.length)];
  }
}
