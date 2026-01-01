import 'package:flutter/material.dart';
import '../services/data_storage.dart';
import '../models/user.dart';
import 'friend_search_screen.dart';
import 'my_page_screen.dart';
import 'call_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> friends = [];
  bool allowFriendRequests = true;

  @override
  void initState() {
    super.initState();
    loadFriends();
    allowFriendRequests = DataStorage.currentUser?.allowFriendRequests ?? true;
  }

  void loadFriends() {
    setState(() {
      friends = DataStorage.getFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム'),
        actions: [
          // メニューバー
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (value) async {
              if (value == 'mypage') {
                // マイページへ遷移
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()),
                );
                // マイページから戻ったら友達リストを更新
                setState(() {
                  allowFriendRequests = DataStorage.currentUser?.allowFriendRequests ?? true;
                });
              } else if (value == 'add_friend') {
                // 友達追加へ遷移
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendSearchScreen()),
                );
                if (result == true) {
                  loadFriends(); // 友達リストを更新
                }
              } else if (value == 'toggle_permission') {
                // 友達追加許可の切り替え
                setState(() {
                  allowFriendRequests = !allowFriendRequests;
                  DataStorage.toggleFriendRequestPermission(allowFriendRequests);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      allowFriendRequests ? '友達追加許可：ON' : '友達追加許可：OFF',
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'mypage',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('マイページ'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'add_friend',
                child: Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.green),
                    SizedBox(width: 8),
                    Text('友達追加'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle_permission',
                child: Row(
                  children: [
                    Icon(
                      allowFriendRequests ? Icons.toggle_on : Icons.toggle_off,
                      color: allowFriendRequests ? Colors.green : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('友達追加許可: ${allowFriendRequests ? "ON" : "OFF"}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 友達リスト
          Expanded(
            child: friends.isEmpty
                ? Center(child: Text('友達がいません'))
                : ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(friend.nickname),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // 通話画面へ遷移
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallScreen(
                                  channelName: 'channel_${DataStorage.currentUser!.id}_${friend.id}',
                                  friendName: friend.nickname,
                                ),
                              ),
                            );
                          },
                          child: Text('通話'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
