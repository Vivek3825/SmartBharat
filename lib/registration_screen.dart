import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bharat_ai/main.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _birthdateController = TextEditingController();
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
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _birthdateController.text = "${picked.day}/${picked.month}/${picked.year}";
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
                            children: [
                              // Name Row
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.firstName,
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
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.middleName,
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
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.lastName,
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
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Phone, Email, Birthdate
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
                              const SizedBox(height: 16),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email, color: Color(0xFF6D4C41)), // Brown
                                  labelText: AppLocalizations.of(context)!.email,
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
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _birthdateController,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.cake, color: Color(0xFF388E3C)),
                                  labelText: AppLocalizations.of(context)!.birthdate,
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
                              const SizedBox(height: 16),
                              // Religion and Caste Row
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.account_balance, color: Color(0xFF388E3C)),
                                        labelText: AppLocalizations.of(context)!.religion,
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
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.group, color: Color(0xFF388E3C)),
                                        labelText: AppLocalizations.of(context)!.caste,
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
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Annual Income
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF6D4C41)), // Brown
                                  labelText: AppLocalizations.of(context)!.annualIncome,
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
                              const SizedBox(height: 24),
                              // Next Button
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
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/set_password');
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.next,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.alreadyHaveAccount,
                                    style: const TextStyle(fontSize: 16, color: Color(0xFF388E3C)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, '/login');
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.loginHere,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
