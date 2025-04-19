import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/localized_text.dart';
import 'providers/language_provider.dart'; // ignore: unused_import

import 'providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Custom color palette (matching your home.dart)
  final Color primaryColor = Color(0xFF3E8E41); // Earthy Green
  final Color secondaryColor = Color(0xFFF4A300); // Golden Yellow
  final Color accentColor = Color(0xFFD94F30); // Brick Orange
  final Color successColor = Color(0xFF2E7D32); // Deep Green
  final Color warningColor = Color(0xFFF9B233); // Bright Yellow
  final Color errorColor = Color(0xFFC62828); // Deep Red
  final Color backgroundColor = Color(0xFFFFF8E1); // Creamy Beige
  final Color cardColor = Color(0xFFFFFFFF); // White
  final Color textPrimary = Color(0xFF212121); // Charcoal Black
  final Color textSecondary = Color(0xFF616161); // Muted Gray

  bool _isLoading = true;
  bool _isEditing = false;
  Map<String, dynamic> _userData = {};
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
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
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user != null) {
        final userId = userProvider.user!.uid;
        
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
            
        if (docSnapshot.exists) {
          setState(() {
            _userData = docSnapshot.data()!;
            _nameController.text = _userData['name'] ?? '';
            _phoneController.text = _userData['phone'] ?? '';
            _birthdateController.text = _userData['birthdate'] ?? '';
            _selectedGender = _userData['gender'];
            _selectedState = _userData['state'];
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profile data: ${e.toString()}'),
          backgroundColor: errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user != null) {
        final userId = userProvider.user!.uid;
        
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'birthdate': _birthdateController.text,
          'gender': _selectedGender,
          'state': _selectedState,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        await _loadUserData();
        
        setState(() {
          _isEditing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: successColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: ${e.toString()}'),
          backgroundColor: errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdateController.text.isNotEmpty 
          ? _parseDate(_birthdateController.text) 
          : DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryColor,
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: primaryColor).copyWith(
              secondary: primaryColor,
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
  
  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[2]), 
        int.parse(parts[1]), 
        int.parse(parts[0])
      );
    }
    return DateTime.now().subtract(const Duration(days: 365 * 18));
  }
  
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileDisplay() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Profile header with avatar
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: primaryColor,
                child: Text(
                  _userData['name']?.isNotEmpty == true
                      ? _userData['name'][0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _userData['name'] ?? 'User',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              Text(
                _userData['email'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Profile details section
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const Divider(),
                _buildInfoRow('Phone', _userData['phone'] ?? 'Not provided'),
                _buildInfoRow('Gender', _userData['gender'] ?? 'Not provided'),
                _buildInfoRow('Birth Date', _userData['birthdate'] ?? 'Not provided'),
                _buildInfoRow('State', _userData['state'] ?? 'Not provided'),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildProfileEdit() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: primaryColor,
              child: Text(
                _nameController.text.isNotEmpty 
                    ? _nameController.text[0].toUpperCase() 
                    : '?',
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Full Name
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person, color: primaryColor),
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
          
          const SizedBox(height: 16),
          
          // Phone Number
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone, color: primaryColor),
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
          
          const SizedBox(height: 16),
          
          // Email (read-only)
          TextFormField(
            initialValue: _userData['email'] ?? '',
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            readOnly: true,
            enabled: false,
          ),
          
          const SizedBox(height: 16),
          
          // Date of Birth
          TextFormField(
            controller: _birthdateController,
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              prefixIcon: Icon(Icons.calendar_today, color: primaryColor),
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
          
          const SizedBox(height: 16),
          
          // Gender
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender',
              prefixIcon: Icon(Icons.people, color: primaryColor),
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
            validator: (value) {
              if (value == null) {
                return 'Please select your gender';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // State
          DropdownButtonFormField<String>(
            value: _selectedState,
            decoration: InputDecoration(
              labelText: 'State',
              prefixIcon: Icon(Icons.location_on, color: primaryColor),
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
            validator: (value) {
              if (value == null) {
                return 'Please select your state';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _updateUserData,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText(
          translationKey: 'profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [backgroundColor, Colors.white],
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : _isEditing
                ? _buildProfileEdit()
                : _buildProfileDisplay(),
      ),
    );
  }
}