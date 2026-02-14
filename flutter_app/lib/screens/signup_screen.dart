import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../constants/retro_theme.dart';
import '../widgets/retro_widgets.dart';
import '../services/auth_service.dart';

/// Sign Up Screen
/// Allows new users to register with email, password, and name
class SignUpScreen extends StatefulWidget {
  final VoidCallback onSignUpSuccess;
  final VoidCallback onSwitchToLogin;

  const SignUpScreen({
    Key? key,
    required this.onSignUpSuccess,
    required this.onSwitchToLogin,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: RetroColors.neonGreen,
            ),
          );
          widget.onSignUpSuccess();
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to create account. Please try again.';
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
                  SizedBox(height: responsive.percentHeight(3)),
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
                    'Create Your Account',
                    style: RetroTypography.retroHeadline,
                  ),
                  SizedBox(height: responsive.percentHeight(3)),

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
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person),
                            hintText: 'Enter your name',
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Name is required';
                            }
                            if (value!.length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                            height:
                                responsive.responsiveDimension(
                                  mobileSize: 16,
                                  tabletSize: 20,
                                  desktopSize: 24,
                                )),

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
                                  mobileSize: 16,
                                  tabletSize: 20,
                                  desktopSize: 24,
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
                            hintText: 'Enter a password',
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Password is required';
                            }
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                            height:
                                responsive.responsiveDimension(
                                  mobileSize: 16,
                                  tabletSize: 20,
                                  desktopSize: 24,
                                )),

                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                );
                              },
                            ),
                            hintText: 'Confirm your password',
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.percentHeight(3)),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: RetroButton(
                      label: _isLoading ? 'Creating Account...' : 'SIGN UP',
                      onPressed: _isLoading ? () {} : _handleSignUp,
                      backgroundColor: RetroColors.neonPurple,
                      height: responsive.responsiveDimension(
                        mobileSize: 48,
                        tabletSize: 52,
                        desktopSize: 56,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.percentHeight(2)),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: RetroTypography.retroBody,
                      ),
                      GestureDetector(
                        onTap: widget.onSwitchToLogin,
                        child: Text(
                          'SIGN IN',
                          style: RetroTypography.retroBody.copyWith(
                            color: RetroColors.neonPurple,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: responsive.percentHeight(3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
