import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('プロフィール')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 40, backgroundColor: Colors.grey),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: '表示名'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
