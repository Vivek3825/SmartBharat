import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'set_password_screen.dart';

void main() {
  runApp(const BharatAIApp());
}

class BharatAIApp extends StatelessWidget {
  const BharatAIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Bharat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/set_password': (context) => const SetPasswordScreen(),
      },
    );
  }
}
