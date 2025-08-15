class User {
  final String nickname;
  final String userId;
  final String avatar; // 默认头像文件名，如 user_01.webp
  final String? customAvatarPath; // 用户自定义头像的本地路径
  final int diamonds;
  final bool isVip;
  final DateTime? vipExpireTime;
  final String gender;
  final int age;
  final String city;
  final String personalityType; // MBTI
  final List<String> registeredActivities;
  final List<ChatMessage> messages;

  User({
    required this.nickname,
    required this.userId,
    required this.avatar,
    this.customAvatarPath,
    required this.diamonds,
    required this.isVip,
    this.vipExpireTime,
    required this.gender,
    required this.age,
    required this.city,
    required this.personalityType,
    this.registeredActivities = const [],
    this.messages = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'userId': userId,
      'avatar': avatar,
      'customAvatarPath': customAvatarPath,
      'diamonds': diamonds,
      'isVip': isVip,
      'vipExpireTime': vipExpireTime?.toIso8601String(),
      'gender': gender,
      'age': age,
      'city': city,
      'personalityType': personalityType,
      'registeredActivities': registeredActivities,
      'messages': messages.map((msg) => msg.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json['nickname'] ?? '',
      userId: json['userId'] ?? '',
      avatar: json['avatar'] ?? '',
      customAvatarPath: json['customAvatarPath'],
      diamonds: json['diamonds'] ?? 0,
      isVip: json['isVip'] ?? false,
      vipExpireTime: json['vipExpireTime'] != null 
          ? DateTime.parse(json['vipExpireTime']) 
          : null,
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      city: json['city'] ?? '',
      personalityType: json['personalityType'] ?? '',
      registeredActivities: List<String>.from(json['registeredActivities'] ?? []),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((msg) => ChatMessage.fromJson(msg))
          .toList() ?? [],
    );
  }

  User copyWith({
    String? nickname,
    String? userId,
    String? avatar,
    String? customAvatarPath,
    int? diamonds,
    bool? isVip,
    DateTime? vipExpireTime,
    String? gender,
    int? age,
    String? city,
    String? personalityType,
    List<String>? registeredActivities,
    List<ChatMessage>? messages,
  }) {
    return User(
      nickname: nickname ?? this.nickname,
      userId: userId ?? this.userId,
      avatar: avatar ?? this.avatar,
      customAvatarPath: customAvatarPath ?? this.customAvatarPath,
      diamonds: diamonds ?? this.diamonds,
      isVip: isVip ?? this.isVip,
      vipExpireTime: vipExpireTime ?? this.vipExpireTime,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      city: city ?? this.city,
      personalityType: personalityType ?? this.personalityType,
      registeredActivities: registeredActivities ?? this.registeredActivities,
      messages: messages ?? this.messages,
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
    );
  }
}

enum MessageType {
  text,
  image,
  voice,
  video,
}
