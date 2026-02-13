import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../constants/retro_theme.dart';
import '../widgets/retro_widgets.dart';
import '../services/auth_service.dart';

/// Login Screen
/// Allows existing users to login with email and password
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onSwitchToSignUp;

  const LoginScreen({
    Key? key,
    required this.onLoginSuccess,
    required this.onSwitchToSignUp,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: RetroColors.neonGreen,
            ),
          );
          widget.onLoginSuccess();
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: RetroColors.retroWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.responsiveDimension(
            mobileSize: 20,
            tabletSize: 40,
            desktopSize: 60,
          )),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  // Header
                  SizedBox(height: responsive.percentHeight(5)),
                  Text(
                    'TaskPilot',
                    style: RetroTypography.retroDisplayLarge.copyWith(
                      fontSize: responsive.responsiveFontSize(
                        mobileSize: 32,
                        tabletSize: 40,
                        desktopSize: 48,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.percentHeight(1)),
                  Text(
                    'Manage Your Tasks & Payments',
                    style: RetroTypography.retroHeadline.copyWith(
                      fontSize: responsive.responsiveFontSize(
                        mobileSize: 16,
                        tabletSize: 18,
                        desktopSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.percentHeight(4)),

                  // Error Message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(RetroSpacing.md),
                      decoration: BoxDecoration(
                        color: RetroColors.error.withOpacity(0.1),
                        border: Border.all(
                          color: RetroColors.error,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: RetroTypography.retroBody.copyWith(
                          color: RetroColors.error,
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.percentHeight(2)),
                  ],

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            hintText: 'Enter your email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Email is required';
                            }
                            if (!value!.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                            height:
                                responsive.responsiveDimension(
                                  mobileSize: 20,
                                  tabletSize: 24,
                                  desktopSize: 28,
                                )),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                            ),
                            hintText: 'Enter your password',
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.percentHeight(3)),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: RetroButton(
                      label: _isLoading ? 'Logging in...' : 'SIGN IN',
                      onPressed: _isLoading ? () {} : _handleLogin,
                      backgroundColor: RetroColors.neonCyan,
                      textColor: RetroColors.retroBlack,
                      height: responsive.responsiveDimension(
                        mobileSize: 48,
                        tabletSize: 52,
                        desktopSize: 56,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.percentHeight(2)),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: RetroTypography.retroBody,
                      ),
                      GestureDetector(
                        onTap: widget.onSwitchToSignUp,
                        child: Text(
                          'SIGN UP',
                          style: RetroTypography.retroBody.copyWith(
                            color: RetroColors.neonOrange,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: responsive.percentHeight(4)),

                  // Features
                  Text(
                    'TaskPilot Features:',
                    style: RetroTypography.retroTitle,
                  ),
                  SizedBox(height: responsive.percentHeight(1.5)),
                  ...[
                    '✓ Task Management',
                    '✓ Client Tracking',
                    '✓ Payment Reminders',
                    '✓ Automated Workflows',
                  ].map((feature) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.percentHeight(0.5),
                      ),
                      child: Text(
                        feature,
                        style: RetroTypography.retroBody,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
