import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bharat_ai/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String? _selectedLanguage = 'en';

  void _changeLanguage(String? langCode) {
    if (langCode == null) return;
    setState(() {
      _selectedLanguage = langCode;
    });
    Locale newLocale = Locale(langCode);
    // Update app locale
    BharatAIApp.setLocale(context, newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF7F4E3), Color(0xFFE8F5E9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Language selector (flags, row, spaced)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 0), // For symmetry
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton.icon(
                                onPressed: () => _changeLanguage('en'),
                                icon: const Icon(Icons.flag, color: Color(0xFF388E3C)),
                                label: Text(AppLocalizations.of(context)!.english, style: const TextStyle(color: Color(0xFF388E3C))),
                              ),
                              const SizedBox(width: 6),
                              TextButton.icon(
                                onPressed: () => _changeLanguage('hi'),
                                icon: const Icon(Icons.flag, color: Color(0xFF388E3C)),
                                label: Text(AppLocalizations.of(context)!.hindi, style: const TextStyle(color: Color(0xFF388E3C))),
                              ),
                              const SizedBox(width: 6),
                              TextButton.icon(
                                onPressed: () => _changeLanguage('mr'),
                                icon: const Icon(Icons.flag, color: Color(0xFF388E3C)),
                                label: Text(AppLocalizations.of(context)!.marathi, style: const TextStyle(color: Color(0xFF388E3C))),
                              ),
                            ],
                          ),
                          const SizedBox(width: 0), // For symmetry
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFF388E3C), // Deep green
                      child: const Icon(Icons.agriculture, color: Color(0xFFFFB300), size: 40), // Harvest yellow
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.appTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFDE7), // Very light yellow
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.loginSlogan,
                                  style: const TextStyle(
                                    color: Color(0xFF388E3C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF6D4C41)), // Brown
                                  labelText: AppLocalizations.of(context)!.phoneNumber,
                                  labelStyle: TextStyle(color: Color(0xFF388E3C)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF6D4C41)),
                                  labelText: AppLocalizations.of(context)!.password,
                                  labelStyle: TextStyle(color: Color(0xFF388E3C)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Color(0xFF388E3C)),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFFB300), // Harvest yellow
                                    foregroundColor: Color(0xFF6D4C41), // Brown
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    AppLocalizations.of(context)!.forgotPassword,
                                    style: const TextStyle(fontSize: 16, color: Color(0xFF388E3C)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dontHaveAccount,
                          style: const TextStyle(fontSize: 16, color: Color(0xFF388E3C)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: Text(
                            AppLocalizations.of(context)!.registerHere,
                            style: const TextStyle(fontSize: 16, color: Color(0xFFFFB300)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
