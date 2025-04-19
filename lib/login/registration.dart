import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/localized_text.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _birthdateController = TextEditingController();
  String? _selectedGender;
  String? _selectedState;

  // List of states - simplified for rural users
  final List<String> _states = [
    'Andhra Pradesh', 'Bihar', 'Gujarat', 'Haryana',
    'Karnataka', 'Madhya Pradesh', 'Maharashtra',
    'Punjab', 'Rajasthan', 'Tamil Nadu', 'Uttar Pradesh'
  ];

  @override
  void dispose() {
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _birthdateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Language and back button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF3E8E41)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      GestureDetector(
                        onTap: () => _showLanguageMenu(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
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
                                  provider.currentLanguageDisplay,
                                  style: const TextStyle(
                                    color: Color(0xFF3E8E41),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF3E8E41),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // App logo/icon
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF3E8E41),
                    child: const Icon(
                      Icons.person_add,
                      color: Color(0xFFF4A300),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // App title
                  const LocalizedText(
                    translationKey: 'appTitle',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color(0xFF3E8E41),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Registration subtitle
                  const LocalizedText(
                    translationKey: 'registerSubtitle',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6D4C41),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Registration form
                  Card(
                    elevation: 4,
                    color: const Color(0xFFFFFDE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Full name field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Full Name', // Add to translations
                                labelStyle: const TextStyle(color: Color(0xFF3E8E41)),
                                prefixIcon: const Icon(Icons.person, color: Color(0xFF6D4C41)),
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
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Phone number
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
                            const SizedBox(height: 16),

                            // Birth date
                            TextFormField(
                              controller: _birthdateController,
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF3E8E41)),
                                labelText: 'Birth Date', // Add to translations
                                labelStyle: const TextStyle(color: Color(0xFF3E8E41)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF3E8E41), width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3E8E41)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your birth date';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Gender selection with visual icons
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 4, bottom: 8),
                                  child: LocalizedText(
                                    translationKey: 'gender',
                                    style: TextStyle(
                                      color: Color(0xFF3E8E41),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedGender = 'male';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _selectedGender == 'male'
                                                ? const Color(0xFF3E8E41).withOpacity(0.2)
                                                : Colors.white,
                                            border: Border.all(
                                              color: _selectedGender == 'male'
                                                  ? const Color(0xFF3E8E41)
                                                  : Colors.grey.shade400,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.male,
                                                color: _selectedGender == 'male'
                                                    ? const Color(0xFF3E8E41)
                                                    : Colors.grey.shade600,
                                                size: 32,
                                              ),
                                              const SizedBox(height: 4),
                                              LocalizedText(
                                                translationKey: 'male',
                                                style: TextStyle(
                                                  color: _selectedGender == 'male'
                                                      ? const Color(0xFF3E8E41)
                                                      : Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedGender = 'female';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _selectedGender == 'female'
                                                ? const Color(0xFF3E8E41).withOpacity(0.2)
                                                : Colors.white,
                                            border: Border.all(
                                              color: _selectedGender == 'female'
                                                  ? const Color(0xFF3E8E41)
                                                  : Colors.grey.shade400,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.female,
                                                color: _selectedGender == 'female'
                                                    ? const Color(0xFF3E8E41)
                                                    : Colors.grey.shade600,
                                                size: 32,
                                              ),
                                              const SizedBox(height: 4),
                                              LocalizedText(
                                                translationKey: 'female',
                                                style: TextStyle(
                                                  color: _selectedGender == 'female'
                                                      ? const Color(0xFF3E8E41)
                                                      : Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // State dropdown with visual styling
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'State', // Add to translations
                                labelStyle: const TextStyle(color: Color(0xFF3E8E41)),
                                prefixIcon: const Icon(Icons.location_on, color: Color(0xFF6D4C41)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF3E8E41), width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              value: _selectedState,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedState = newValue;
                                });
                              },
                              items: _states.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: const Text('Select your state'), // Add to translations
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your state';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Next Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF4A300),
                                  foregroundColor: const Color(0xFF6D4C41),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate() && _selectedGender != null) {
                                    Navigator.pushNamed(context, '/set_password');
                                  } else if (_selectedGender == null) {
                                    // Show a snackbar if gender is not selected
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please select your gender'),
                                        backgroundColor: Color(0xFFD32F2F),
                                      ),
                                    );
                                  }
                                },
                                child: const LocalizedText(
                                  translationKey: 'next',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Already have an account section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LocalizedText(
                          translationKey: 'alreadyHaveAccount',
                          style: TextStyle(fontSize: 16, color: Color(0xFF3E8E41)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const LocalizedText(
                            translationKey: 'loginHere',
                            style: TextStyle(fontSize: 16, color: Color(0xFFF4A300)),
                          ),
                        ),
                      ],
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