import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  // Default language index
  int _currentLanguageIndex = 0;
  
  // Available languages
  final List<Map<String, dynamic>> languages = [
    {'code': 'हिंदी', 'name': 'Hindi', 'locale': 'hi'},
    {'code': 'ENG', 'name': 'English', 'locale': 'en'},
    {'code': 'मराठी', 'name': 'Marathi', 'locale': 'mr'},
    {'code': 'தமிழ்', 'name': 'Tamil', 'locale': 'ta'},
    {'code': 'తెలుగు', 'name': 'Telugu', 'locale': 'te'},
  ];
  
  // Constructor - load saved language preference
  LanguageProvider() {
    loadSavedLanguage();
  }

  // Getters
  int get currentLanguageIndex => _currentLanguageIndex;
  String get currentLanguageCode => languages[_currentLanguageIndex]['locale'];
  String get currentLanguageDisplay => languages[_currentLanguageIndex]['code'];
  String get currentLanguageName => languages[_currentLanguageIndex]['name'];
  
  // Change language and save preference
  Future<void> setLanguage(int index) async {
    if (index >= 0 && index < languages.length) {
      _currentLanguageIndex = index;
      notifyListeners();
      
      // Save preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('language_index', index);
    }
  }
  
  // Load saved language preference
  Future<void> loadSavedLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? savedIndex = prefs.getInt('language_index');
      
      if (savedIndex != null && savedIndex >= 0 && savedIndex < languages.length) {
        _currentLanguageIndex = savedIndex;
        notifyListeners();
      }
    } catch (e) {
      // Handle any potential errors when loading saved preferences
      print('Error loading saved language: $e');
    }
  }
}