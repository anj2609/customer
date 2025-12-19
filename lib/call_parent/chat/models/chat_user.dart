class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.onlineStatus,
    required this.id,
    required this.lastActive,
    required this.lastActiveStatus,
    required this.email,
    required this.pushToken,
  });
  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late int onlineStatus;
  late String id;
  late String lastActive;
  late int lastActiveStatus;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    onlineStatus=json['online_status'] ?? 0;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    lastActiveStatus = json['last_active_status'] ?? 0;
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['online_status'] = onlineStatus;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['last_active_status'] = lastActiveStatus;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
