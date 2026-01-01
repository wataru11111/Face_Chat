import '../models/user.dart';

// 簡易的なデータストレージ（実際はデータベースやAPIを使用）
class DataStorage {
  static User? currentUser; // 現在ログイン中のユーザー
  static List<User> allUsers = []; // 全ユーザー
  static Map<String, List<String>> friendships = {}; // ユーザーIDと友達IDのマップ

  // ユーザー登録
  static void registerUser(String nickname, String phoneNumber, String password) {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nickname: nickname,
      phoneNumber: phoneNumber,
      allowFriendRequests: true,
    );
    allUsers.add(user);
    currentUser = user;
    friendships[user.id] = [];
  }

  // ログイン
  static bool login(String phoneNumber, String password) {
    // 簡易的なログイン処理
    final user = allUsers.firstWhere(
      (u) => u.phoneNumber == phoneNumber,
      orElse: () => User(id: '', nickname: '', phoneNumber: ''),
    );
    if (user.id.isNotEmpty) {
      currentUser = user;
      return true;
    }
    return false;
  }

  // ユーザーIDで検索（友達追加許可がONのユーザーのみ）
  static User? searchUserById(String userId) {
    try {
      final user = allUsers.firstWhere(
        (u) =>
            u.id == userId &&
            u.allowFriendRequests &&
            u.id != currentUser?.id,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  // 友達追加
  static void addFriend(String friendId) {
    if (currentUser != null && !friendships[currentUser!.id]!.contains(friendId)) {
      friendships[currentUser!.id]!.add(friendId);
    }
  }

  // 友達リスト取得
  static List<User> getFriends() {
    if (currentUser == null) return [];
    final friendIds = friendships[currentUser!.id] ?? [];
    return allUsers.where((u) => friendIds.contains(u.id)).toList();
  }

  // 友達追加許可の切り替え
  static void toggleFriendRequestPermission(bool allow) {
    if (currentUser != null) {
      currentUser!.allowFriendRequests = allow;
    }
  }
}
