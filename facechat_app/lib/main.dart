import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(FaceChatApp());
}

class FaceChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaceChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
