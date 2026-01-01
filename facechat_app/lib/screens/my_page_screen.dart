import 'package:flutter/material.dart';
import '../services/data_storage.dart';
import '../models/user.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = DataStorage.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('マイページ')),
      body: currentUser == null
          ? Center(child: Text('ユーザー情報がありません'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                  ),
                  SizedBox(height: 24),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.badge),
                      title: Text('ニックネーム'),
                      subtitle: Text(currentUser.nickname),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('電話番号'),
                      subtitle: Text(currentUser.phoneNumber),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.vpn_key),
                      title: Text('ユーザーID'),
                      subtitle: Text(currentUser.id),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.people),
                      title: Text('友達追加許可'),
                      subtitle: Text(
                        currentUser.allowFriendRequests ? '許可中' : '拒否中',
                      ),
                      trailing: Icon(
                        currentUser.allowFriendRequests
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: currentUser.allowFriendRequests
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: ログアウト処理
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      icon: Icon(Icons.logout),
                      label: Text('ログアウト'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
