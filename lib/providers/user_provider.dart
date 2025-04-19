import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_auth_service.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = true; // Start with loading true
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  // Constructor - listen to auth state changes
  UserProvider() {
    _init();
  }

  void _init() {
    // Listen to authentication state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      _isLoading = false; // Set loading to false once we have a result
      notifyListeners();
    });
  }

  // Login functionality
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      _user = result.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Registration functionality
  Future<bool> register(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      _user = result.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout functionality
  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  // Helper method to handle Firebase Auth errors
  String _handleAuthError(dynamic error) {
    String message = "An unknown error occurred";
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          message = "No user found with this email";
          break;
        case 'wrong-password':
          message = "Wrong password";
          break;
        case 'email-already-in-use':
          message = "Email already in use";
          break;
        case 'weak-password':
          message = "Password is too weak";
          break;
        case 'invalid-email':
          message = "Invalid email address";
          break;
        default:
          message = error.message ?? "Authentication error";
      }
    }
    return message;
  }
}