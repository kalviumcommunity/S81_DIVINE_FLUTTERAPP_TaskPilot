import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'authentication_screen.dart';
import 'home_screen.dart';

/// AuthWrapper handles the routing between authenticated and unauthenticated states.
/// 
/// This widget listens to the AuthProvider and displays either:
/// - AuthenticationScreen if the user is not logged in
/// - HomeScreen if the user is logged in
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
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
