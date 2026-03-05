import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'authentication_screen.dart';
import 'home_screen.dart';
import 'splash_screen.dart';

/// AuthWrapper handles the routing between authenticated and unauthenticated states.
/// 
/// This widget listens to the AuthProvider and displays:
/// - SplashScreen while checking initial auth state
/// - AuthenticationScreen if the user is not logged in
/// - HomeScreen if the user is logged in
/// 
/// Session Persistence Flow:
/// 1. App launches → SplashScreen appears
/// 2. AuthProvider checks cached Firebase token (~1-3 seconds)
/// 3. If logged in → HomeScreen (auto-login)
/// 4. If logged out → AuthenticationScreen
/// 5. User stays logged in across app restarts (persistent session)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show splash screen while checking auth state
        // This happens when app first launches and Firebase checks for cached tokens
        if (authProvider.isCheckingAuth) {
          return const SplashScreen();
        }

        // Show home screen if authenticated, otherwise show auth screen
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const AuthenticationScreen();
        }
      },
    );
  }
}

