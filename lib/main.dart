import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'login/login.dart';
import 'login/registration.dart';
import 'login/setpass.dart';
import 'home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const SmartBharatApp(),
    ),
  );
}

class SmartBharatApp extends StatelessWidget {
  const SmartBharatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Bharat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3E8E41)),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Change initial route to login page
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/set_password': (context) => const SetPasswordPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
