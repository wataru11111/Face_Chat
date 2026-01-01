import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/data_storage.dart';

class FriendSearchScreen extends StatefulWidget {
  @override
  _FriendSearchScreenState createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  User? searchResult;
  bool hasSearched = false;

  void searchUser() {
    setState(() {
      hasSearched = true;
      searchResult = DataStorage.searchUserById(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('友達検索')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'ユーザーIDで検索',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: searchUser,
                  child: Text('検索'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: !hasSearched
                  ? Center(child: Text('ユーザーIDを入力して検索してください'))
                  : searchResult == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'ユーザーが見つかりませんでした',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '・ユーザーIDが正しいか確認してください\n・相手が友達追加許可をOFFにしている可能性があります',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(searchResult!.nickname),
                            subtitle: Text('ID: ${searchResult!.id}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                DataStorage.addFriend(searchResult!.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${searchResult!.nickname}を友達に追加しました'),
                                  ),
                                );
                                Navigator.pop(context, true); // 更新フラグを返す
                              },
                              child: Text('追加'),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
