import 'package:flutter/material.dart';
import 'package:social_media_app/screens/sing_up_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: SingUpScreen(),
    );
  }
}
