import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新規登録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: '電話番号'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: '表示名'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: Text('登録'),
            ),
          ],
        ),
      ),
    );
  }
}
