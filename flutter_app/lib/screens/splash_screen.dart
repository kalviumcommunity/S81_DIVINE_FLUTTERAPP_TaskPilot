import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';

/// SplashScreen displays while Firebase checks the user's authentication state.
/// 
/// This elegant loading screen:
/// - Shows app branding (logo/title)
/// - Displays a loading indicator
/// - Smoothly transitions to either HomeScreen or AuthenticationScreen
/// - Provides visual feedback during the initial auth state check
/// 
/// Visible during:
/// - App first loads (Firebase checking cached tokens)
/// - Session state detection (~1-3 seconds typically)
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Create animation controller for smooth transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation: 0.0 to 1.0
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Scale animation: 0.8 to 1.0
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[900] ?? Colors.purple,
              Colors.blue[900] ?? Colors.blue,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo/Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      // App Icon with retro style
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: RetroColors.neonPurple,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: RetroColors.neonPurple.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in,
                          size: 60,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // App Title
                      Text(
                        'TaskPilot',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        'Managing Your Tasks with Style',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.cyan[300],
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),

              // Loading indicator with retro style
              Column(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        RetroColors.neonCyan,
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Checking your session...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '(Your session is automatically restored)',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Footer info
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Text(
                      '✨ Powered by Firebase Authentication',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🔐 Your data is secure and encrypted',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
