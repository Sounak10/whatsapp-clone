class UserData {
  UserData({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.pushToken,
    required this.email,
  });
  late String about;
  late String name;
  late String image;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String pushToken;
  late String email;

  UserData.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
