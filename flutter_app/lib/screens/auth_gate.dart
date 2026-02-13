import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/responsive_home.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

/// Authentication Gate
/// Routes users to login/signup or home based on authentication state
class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const ResponsiveHome();
        }

        // User is not logged in - show auth screens
        return _isSignUp
            ? SignUpScreen(
                onSignUpSuccess: () {
                  setState(() => _isSignUp = false);
                },
                onSwitchToLogin: () {
                  setState(() => _isSignUp = false);
                },
              )
            : LoginScreen(
                onLoginSuccess: () {
                  // Home screen is automatically shown by StreamBuilder
                },
                onSwitchToSignUp: () {
                  setState(() => _isSignUp = true);
                },
              );
      },
    );
  }
}
