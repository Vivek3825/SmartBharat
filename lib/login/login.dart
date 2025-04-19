import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/localized_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _showLanguageMenu(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet height flexible
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Select Language / भाषा चुनें',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(
                    languageProvider.languages.length,
                    (index) => GestureDetector(
                      onTap: () {
                        languageProvider.setLanguage(index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: languageProvider.currentLanguageIndex == index
                              ? const Color(0xFF3E8E41)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: const Color(0xFF3E8E41),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          languageProvider.languages[index]['name'],
                          style: TextStyle(
                            color: languageProvider.currentLanguageIndex == index
                                ? Colors.white
                                : const Color(0xFF3E8E41),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F4E3), Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Language selector in top right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => _showLanguageMenu(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: const Color(0xFF3E8E41),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Consumer<LanguageProvider>(
                                builder: (context, provider, _) => Text(
                                  provider.currentLanguageIndex == 3 ? "தமிழ்" : provider.currentLanguageDisplay,
                                  style: TextStyle(
                                    color: const Color(0xFF3E8E41),
                                    fontWeight: FontWeight.bold,
                                    fontSize: provider.currentLanguageIndex == 3 ? 12 : 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF3E8E41),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // App Logo/Icon - make it bigger for better recognition
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF3E8E41),
                    child: const Icon(
                      Icons.agriculture,
                      color: Color(0xFFF4A300),
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // App Title
                  const LocalizedText(
                    translationKey: 'appTitle',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF3E8E41),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // App subtitle with explanation
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: LocalizedText(
                      translationKey: 'appSubtitle',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6D4C41),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Login Card with simplified interface
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Provider.of<LanguageProvider>(context).currentLanguageIndex == 3 ? 16.0 : 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Visual phone icon at the top
                            const Icon(
                              Icons.smartphone,
                              color: Color(0xFF3E8E41),
                              size: 40,
                            ),
                            SizedBox(height: Provider.of<LanguageProvider>(context).currentLanguageIndex == 3 ? 8 : 16),
                            
                            // Welcome text
                            const LocalizedText(
                              translationKey: 'loginSlogan',
                              style: TextStyle(
                                color: Color(0xFF3E8E41),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            
                            // Phone number field with clear visual
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone, color: Color(0xFF6D4C41)),
                                labelText: 'Phone Number', // Add to translations
                                labelStyle: const TextStyle(color: Color(0xFF3E8E41)),
                                hintText: '10-digit number', // Add to translations
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF3E8E41), width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (value.length != 10) {
                                  return 'Please enter a valid 10-digit number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            
                            // Password field with visibility toggle
                            TextFormField(
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock, color: Color(0xFF6D4C41)),
                                labelText: 'Password', // Add to translations
                                labelStyle: const TextStyle(color: Color(0xFF3E8E41)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF3E8E41), width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: const Color(0xFF3E8E41),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Login Button - large and prominent
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF4A300),
                                  foregroundColor: const Color(0xFF6D4C41),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pushReplacementNamed(context, '/home');
                                  }
                                },
                                child: const LocalizedText(
                                  translationKey: 'login',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  adaptSize: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            
                            // Forgot password link
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: TextButton(
                                onPressed: () {},
                                child: const LocalizedText(
                                  translationKey: 'forgotPassword',
                                  style: TextStyle(fontSize: 16, color: Color(0xFF3E8E41)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Register section with auto text scaling
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: FittedBox( // This will automatically scale down text to fit
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min, // Important for proper centering
                        children: [
                          LocalizedText(
                            translationKey: 'dontHaveAccount',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF3E8E41),
                            ),
                            adaptSize: true, // Enable size adaptation
                            maxLines: 1,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/register');
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 4), // Reduced padding
                            ),
                            child: LocalizedText(
                              translationKey: 'registerHere',
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFFF4A300),
                              ),
                              adaptSize: true, // Enable size adaptation
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}