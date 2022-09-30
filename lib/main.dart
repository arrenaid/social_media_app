import 'package:flutter/material.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: SignUpScreen(),
      routes: {
        SignUpScreen.id: (context) => SignUpScreen(),
        SignInScreen.id: (context) => SignInScreen(),
      },
    );
  }
}
