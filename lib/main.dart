import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/language_provider.dart';
import 'providers/user_provider.dart';
import 'login/login.dart';
import 'login/registration.dart';
import 'login/setpass.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
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
      home: const AuthWrapper(), // Use AuthWrapper instead of routes
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/set_password': (context) => const SetPasswordPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

// Auth wrapper to check authentication status
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes from UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    
    // Show loading indicator while determining auth state
    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3E8E41),
          ),
        ),
      );
    }
    
    // Navigate based on authentication
    if (userProvider.isLoggedIn) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
