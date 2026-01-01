class User {
  final String id;
  final String nickname;
  final String phoneNumber;
  bool allowFriendRequests; // 友達追加許可

  User({
    required this.id,
    required this.nickname,
    required this.phoneNumber,
    this.allowFriendRequests = true,
  });
}
