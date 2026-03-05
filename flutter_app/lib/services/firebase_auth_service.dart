import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// FirebaseAuthService handles all authentication operations
/// including signup, login, logout, and password reset.
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get the current user's email
  String? get userEmail => _auth.currentUser?.email;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign up with email and password
  ///
  /// [email]: The email address for the new account
  /// [password]: The password for the new account (must be at least 6 characters)
  ///
  /// Returns the created [UserCredential] on success,
  /// or throws a [FirebaseAuthException] on failure.
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Attempting signup with email: $email');
      
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      debugPrint('Signup successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Signup error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during signup: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  ///
  /// [email]: The email address of the account
  /// [password]: The password of the account
  ///
  /// Returns the [UserCredential] on success,
  /// or throws a [FirebaseAuthException] on failure.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Attempting signin with email: $email');
      
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      debugPrint('Signin successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Signin error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during signin: $e');
      rethrow;
    }
  }

  /// Sign out the current user
  ///
  /// Returns a Future that completes when sign out is complete.
  Future<void> signOut() async {
    try {
      debugPrint('Attempting sign out');
      await _auth.signOut();
      debugPrint('Sign out successful');
    } catch (e) {
      debugPrint('Error during sign out: $e');
      rethrow;
    }
  }

  /// Send password reset email
  ///
  /// [email]: The email address of the account
  ///
  /// Returns a Future that completes when the email is sent.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      debugPrint('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email.trim());
      debugPrint('Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during password reset: $e');
      rethrow;
    }
  }

  /// Update user email
  ///
  /// [newEmail]: The new email address
  ///
  /// Note: User must have been recently authenticated for this to work.
  Future<void> updateUserEmail({required String newEmail}) async {
    try {
      debugPrint('Attempting to update email to: $newEmail');
      await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail.trim());
      debugPrint('Email update request sent, verification email sent');
    } on FirebaseAuthException catch (e) {
      debugPrint('Update email error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during email update: $e');
      rethrow;
    }
  }

  /// Update user password
  ///
  /// [newPassword]: The new password (must be at least 6 characters)
  ///
  /// Note: User must have been recently authenticated for this to work.
  Future<void> updateUserPassword({required String newPassword}) async {
    try {
      debugPrint('Attempting to update password');
      await _auth.currentUser?.updatePassword(newPassword);
      debugPrint('Password updated successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('Update password error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during password update: $e');
      rethrow;
    }
  }

  /// Delete current user account
  ///
  /// Note: User must have been recently authenticated for this to work.
  /// This is irreversible and will also delete any data associated with the user.
  Future<void> deleteUser() async {
    try {
      debugPrint('Attempting to delete user account');
      await _auth.currentUser?.delete();
      debugPrint('User account deleted successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('Delete user error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during user deletion: $e');
      rethrow;
    }
  }

  /// Get error message from FirebaseAuthException
  ///
  /// Converts Firebase error codes to user-friendly messages.
  static String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'user-disabled':
        return 'The user account has been disabled by an administrator.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-credential':
        return 'The credentials provided are invalid.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
