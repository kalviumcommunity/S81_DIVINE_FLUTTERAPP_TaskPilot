import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';

/// AuthProvider manages authentication state using the Provider pattern.
/// 
/// This notifier tracks:
/// - Current user and authentication status
/// - Loading states during auth operations
/// - Error messages from failed operations
class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSignUp = false;
  bool _isCheckingAuth = true; // True while waiting for initial auth state

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignUp => _isSignUp;
  String? get userEmail => _user?.email;
  bool get isCheckingAuth => _isCheckingAuth; // Whether we're checking initial auth state

  AuthProvider() {
    // Listen to authentication state changes
    // The first emission indicates the initial auth state has been checked
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      _isCheckingAuth = false; // Auth state determined, stop showing splash
      notifyListeners();
    });
  }

  /// Toggle between signup and login modes
  void toggleAuthMode() {
    _isSignUp = !_isSignUp;
    _errorMessage = null;
    notifyListeners();
  }

  /// Set signup mode explicitly
  void setSignUpMode(bool value) {
    _isSignUp = value;
    _errorMessage = null;
    notifyListeners();
  }

  /// Handle signup with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validate inputs
    if (email.isEmpty) {
      _errorMessage = 'Please enter an email address';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    if (password.isEmpty) {
      _errorMessage = 'Please enter a password';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUp(
        email: email,
        password: password,
      );
      _isSignUp = false; // Switch to login view after successful signup
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = FirebaseAuthService.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Handle signin with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    // Validate inputs
    if (email.isEmpty) {
      _errorMessage = 'Please enter an email address';
      notifyListeners();
      return false;
    }

    if (password.isEmpty) {
      _errorMessage = 'Please enter a password';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = FirebaseAuthService.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Handle sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      _errorMessage = null;
      _isSignUp = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to sign out';
      notifyListeners();
    }
  }

  /// Handle password reset
  Future<bool> sendPasswordResetEmail({required String email}) async {
    if (email.isEmpty) {
      _errorMessage = 'Please enter an email address';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email: email);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = FirebaseAuthService.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
