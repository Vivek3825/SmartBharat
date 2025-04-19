import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bharat_ai/main.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedLanguage = 'en';

  void _changeLanguage(String? langCode) {
    if (langCode == null) return;
    setState(() {
      _selectedLanguage = langCode;
    });
    Locale newLocale = Locale(langCode);
    BharatAIApp.setLocale(context, newLocale);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Handle password submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.passwordSetSuccessfully)),
      );
      // Navigate or process as needed
    }
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
                    const SizedBox(height: 16),
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
                        color: Color(0xFF388E3C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 4,
                      color: Color(0xFFFFFDE7), // Very light yellow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _passwordController,
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.setPassword;
                                  }
                                  if (value.length < 6) {
                                    return AppLocalizations.of(context)!.passwordLength;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6D4C41)),
                                  labelText: AppLocalizations.of(context)!.confirmPassword,
                                  labelStyle: TextStyle(color: Color(0xFF388E3C)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, color: Color(0xFF388E3C)),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.confirmPassword;
                                  }
                                  if (value != _passwordController.text) {
                                    return AppLocalizations.of(context)!.passwordsDoNotMatch;
                                  }
                                  return null;
                                },
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
                                  onPressed: _submit,
                                  child: Text(
                                    AppLocalizations.of(context)!.submit,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 48,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF388E3C), size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
