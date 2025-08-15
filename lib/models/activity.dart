import 'package:flutter/foundation.dart';

enum ActivityType { buddy, normal }

actionTypeFromString(String value) {
  switch (value) {
    case 'buddy':
      return ActivityType.buddy;
    case 'normal':
    default:
      return ActivityType.normal;
  }
}

class ActivityModel {
  final String id;
  final String title;
  final String description;
  final String cover; // 本地封面资源名（activity_<id>.webp），可为空
  final String location;
  final int eventTime; // 时间戳（ms）
  final int requiredPeople;
  final int maxPeople;
  final int joinedPeople;
  final String publisherGender; // 男/女
  final String publisherNickname;
  final String publisherAvatar; // 头像资源或URL
  final String publisherId;
  final ActivityType type;
  final bool isJoined;
  final String personalityTag; // MBTI或其它
  final String activityType; // 新增：活动类型（宠物、电影、干饭等）
  final String requirements; // 新增：活动要求
  final int registeredCount; // 新增：报名人数
  final bool isDraft; // 新增：是否为草稿
  final String? audioFile; // 新增：音频文件

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
    required this.location,
    required this.eventTime,
    required this.requiredPeople,
    required this.maxPeople,
    required this.joinedPeople,
    required this.publisherGender,
    required this.publisherNickname,
    required this.publisherAvatar,
    required this.publisherId,
    required this.type,
    required this.isJoined,
    required this.personalityTag,
    required this.activityType,
    required this.requirements,
    required this.registeredCount,
    this.isDraft = false,
    this.audioFile,
  });

  ActivityModel copyWith({
    bool? isJoined,
    int? joinedPeople,
    bool? isDraft,
    String? audioFile,
  }) {
    return ActivityModel(
      id: id,
      title: title,
      description: description,
      cover: cover,
      location: location,
      eventTime: eventTime,
      requiredPeople: requiredPeople,
      maxPeople: maxPeople,
      joinedPeople: joinedPeople ?? this.joinedPeople,
      publisherGender: publisherGender,
      publisherNickname: publisherNickname,
      publisherAvatar: publisherAvatar,
      publisherId: publisherId,
      type: type,
      isJoined: isJoined ?? this.isJoined,
      personalityTag: personalityTag,
      activityType: activityType,
      requirements: requirements,
      registeredCount: registeredCount,
      isDraft: isDraft ?? this.isDraft,
      audioFile: audioFile ?? this.audioFile,
    );
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cover: json['cover'] as String? ?? '',
      location: json['location'] as String,
      eventTime: (json['event_time'] as num?)?.toInt() ?? 0,
      requiredPeople: (json['required_people'] as num?)?.toInt() ?? 0,
      maxPeople: (json['max_people'] as num?)?.toInt() ?? 0,
      joinedPeople: (json['joined_people'] as num?)?.toInt() ?? 0,
      publisherGender: json['publisher_gender'] as String? ?? '女',
      publisherNickname: json['publisher_nickname'] as String? ?? '',
      publisherAvatar: (() {
        final value = json['publisher_avatar'] as String? ?? '';
        print('ActivityModel.fromJson: publisher_avatar = $value');
        return value;
      })(),
      publisherId: json['publisher_id'] as String,
      type: actionTypeFromString(json['type'] as String? ?? 'normal'),
      isJoined: json['is_joined'] as bool? ?? false,
      personalityTag: json['personality_tag'] as String? ?? 'ENFP',
      activityType: json['activity_type'] as String? ?? '摄影',
      requirements: json['requirements'] as String? ?? '',
      registeredCount: (json['registered_count'] as num?)?.toInt() ?? 0,
      isDraft: json['is_draft'] as bool? ?? false,
      audioFile: json['audio_file'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cover': cover,
      'location': location,
      'event_time': eventTime,
      'required_people': requiredPeople,
      'max_people': maxPeople,
      'joined_people': joinedPeople,
      'publisher_gender': publisherGender,
      'publisher_nickname': publisherNickname,
      'publisher_avatar': publisherAvatar,
      'publisher_id': publisherId,
      'type': describeEnum(type),
      'is_joined': isJoined,
      'personality_tag': personalityTag,
      'activity_type': activityType,
      'requirements': requirements,
      'registered_count': registeredCount,
      'is_draft': isDraft,
      'audio_file': audioFile,
    };
  }
}
