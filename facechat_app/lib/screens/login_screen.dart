import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import '../services/data_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // ログイン処理
                if (DataStorage.login(phoneController.text, passwordController.text)) {
                  // ログイン成功
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  // ログイン失敗
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ログインに失敗しました')),
                  );
                }
              },
              child: Text('ログイン'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('新規登録はこちら'),
            ),
          ],
        ),
      ),
    );
  }
}
