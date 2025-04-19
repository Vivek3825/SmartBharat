import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/language_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/localized_text.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdateController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedState;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // List of states - simplified for rural users
  final List<String> _states = [
    'Andhra Pradesh', 'Bihar', 'Gujarat', 'Haryana',
    'Karnataka', 'Madhya Pradesh', 'Maharashtra',
    'Punjab', 'Rajasthan', 'Tamil Nadu', 'Uttar Pradesh'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF3E8E41),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(primary: Color(0xFF3E8E41)).copyWith(
              secondary: const Color(0xFF3E8E41),
            ),
          ),
          child: child!,
        );
      },
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Language / भाषा चुनें',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  languageProvider.languages.length,
                  (index) => ElevatedButton(
                    onPressed: () {
                      languageProvider.setLanguage(index);
                      Navigator.pop(context);
                    },
                    child: Text(languageProvider.languages[index]['code']),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedState == null || _selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select gender and state'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        
        bool success = await userProvider.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // Even if the widget is unmounted, the provider state will be updated
        
        if (!mounted) return;

        if (success) {
          // Store additional user info in Firestore
          await FirebaseFirestore.instance.collection('users').doc(userProvider.user!.uid).set({
            'name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'birthdate': _birthdateController.text,
            'gender': _selectedGender,
            'state': _selectedState,
            'createdAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate to home page
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userProvider.error ?? 'Registration failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        // Always reset loading state, even if exceptions occur
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText(
          translationKey: 'registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3E8E41),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageMenu(context),
          ),
        ],
      ),
      body: Container(
        // Make container take full remaining height
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
        ),
        child: SafeArea(
          // Set top to false since we have AppBar already handling safe area
          top: false,
          // Set bottom to false to extend below safe area
          bottom: false,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              // Ensure content fills at least the whole screen
              constraints: BoxConstraints(
                minHeight: size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person, color: Color(0xFF3E8E41)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Phone Number
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone, color: Color(0xFF3E8E41)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length != 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Color(0xFF3E8E41)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Password
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Color(0xFF3E8E41)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xFF3E8E41),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Date of Birth
                      TextFormField(
                        controller: _birthdateController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF3E8E41)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Gender
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.people, color: Color(0xFF3E8E41)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: ['Male', 'Female', 'Other'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // State
                      DropdownButtonFormField<String>(
                        value: _selectedState,
                        decoration: InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Icons.location_on, color: Color(0xFF3E8E41)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: _states.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedState = newValue!;
                          });
                        },
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3E8E41),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Register', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Login option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Color(0xFF3E8E41)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}