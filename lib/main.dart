import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'set_password_screen.dart';

void main() {
  runApp(const BharatAIApp());
}

class BharatAIApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _BharatAIAppState? state = context.findAncestorStateOfType<_BharatAIAppState>();
    state?.setLocale(newLocale);
  }

  const BharatAIApp({Key? key}) : super(key: key);

  @override
  State<BharatAIApp> createState() => _BharatAIAppState();
}

class _BharatAIAppState extends State<BharatAIApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Bharat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color(0xFF388E3C), // Deep green (fields)
        scaffoldBackgroundColor: Color(0xFFF7F4E3), // Soft off-white (rural calm)
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF6D4C41), // Rich brown (earth)
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFB300), // Warm harvest yellow
            foregroundColor: Colors.brown[900],
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardColor: Color(0xFFFFFDE7), // Very light yellow (sunlight)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFE8F5E9), // Soft green
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFF388E3C),
            fontWeight: FontWeight.bold,
          ),
          bodyText2: TextStyle(
            color: Color(0xFF4E342E), // Deep brown
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
          secondary: Color(0xFFFFB300), // Harvest yellow
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
      ],
      locale: _locale,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/set_password': (context) => const SetPasswordScreen(),
      },
    );
  }
}
