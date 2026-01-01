import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/data_storage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
              controller: nicknameController,
              decoration: InputDecoration(labelText: 'ニックネーム'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: '電話番号'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'パスワード（確認）'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 入力チェック
                if (nicknameController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('すべての項目を入力してください')),
                  );
                  return;
                }
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('パスワードが一致しません')),
                  );
                  return;
                }

                // ユーザー登録
                DataStorage.registerUser(
                  nicknameController.text,
                  phoneController.text,
                  passwordController.text,
                );

                // ホーム画面へ遷移
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('登録'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ログイン画面に戻る
              },
              child: Text('ログイン画面に戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
