import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/retro_theme.dart';

/// AuthenticationScreen handles both login and signup functionality.
/// 
/// Features:
/// - Toggle between login and signup modes
/// - Email and password validation
/// - Real-time error message display
/// - Loading state management
/// - Responsive layout for different screen sizes
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password strength
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate confirm password matches
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Handle authentication (login or signup)
  Future<void> _handleAuth(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool success;

    if (authProvider.isSignUp) {
      final confirmPassword = _confirmPasswordController.text;
      success = await authProvider.signUp(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
    } else {
      success = await authProvider.signIn(
        email: email,
        password: password,
      );
    }

    if (success && mounted) {
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.isSignUp 
              ? 'Account created successfully! Welcome to TaskPilot 🎉'
              : 'Login successful! Welcome back 👋',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Authentication failed',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Clear all input fields
  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _showPassword = false;
    _showConfirmPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskPilot Authentication'),
        backgroundColor: RetroColors.neonPurple,
        elevation: 8.0,
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(authProvider),
                  const SizedBox(height: 32.0),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email field
                        _buildEmailField(),
                        const SizedBox(height: 16.0),

                        // Password field
                        _buildPasswordField(),
                        const SizedBox(height: 16.0),

                        // Confirm password field (only for signup)
                        if (authProvider.isSignUp) ...[
                          _buildConfirmPasswordField(),
                          const SizedBox(height: 16.0),
                        ],

                        // Error message display
                        if (authProvider.errorMessage != null)
                          _buildErrorWidget(authProvider.errorMessage!),

                        const SizedBox(height: 24.0),

                        // Submit button
                        _buildAuthButton(authProvider),

                        const SizedBox(height: 16.0),

                        // Toggle auth mode button
                        _buildToggleModeButton(authProvider),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32.0),

                  // Additional info
                  _buildInfoSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(AuthProvider authProvider) {
    return Column(
      children: [
        const Icon(
          Icons.security_rounded,
          size: 64.0,
          color: Color.fromARGB(255, 191, 144, 0),
        ),
        const SizedBox(height: 16.0),
        Text(
          authProvider.isSignUp ? 'Create Account' : 'Welcome Back',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: RetroColors.neonPurple,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        Text(
          authProvider.isSignUp
              ? 'Sign up to start managing your tasks'
              : 'Sign in to access your tasks and payments',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build email input field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: RetroColors.neonPurple,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      validator: _validateEmail,
    );
  }

  /// Build password input field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: RetroColors.neonPurple,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      validator: _validatePassword,
    );
  }

  /// Build confirm password input field (for signup)
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_showConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _showConfirmPassword = !_showConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: RetroColors.neonPurple,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      validator: _validateConfirmPassword,
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.red[100],
        border: Border.all(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Build authentication button
  Widget _buildAuthButton(AuthProvider authProvider) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return ElevatedButton(
          onPressed: authProvider.isLoading
              ? null
              : () => _handleAuth(authProvider),
          style: ElevatedButton.styleFrom(
            backgroundColor: RetroColors.neonPurple,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 4.0,
          ),
          child: authProvider.isLoading
              ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.0,
                  ),
                )
              : Text(
                  authProvider.isSignUp ? 'Create Account' : 'Sign In',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }

  /// Build toggle mode button
  Widget _buildToggleModeButton(AuthProvider authProvider) {
    return TextButton(
      onPressed: authProvider.isLoading
          ? null
          : () => authProvider.toggleAuthMode(),
      child: RichText(
        text: TextSpan(
          text: authProvider.isSignUp
              ? 'Already have an account? '
              : "Don't have an account? ",
          style: TextStyle(color: Colors.grey[700]),
          children: [
            TextSpan(
              text: authProvider.isSignUp ? 'Sign In' : 'Sign Up',
              style: const TextStyle(
                color: RetroColors.neonPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build info section
  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔒 Security Information',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            '• Your password is secured by Firebase Authentication\n'
            '• We never store plain text passwords\n'
            '• All data is encrypted in transit\n'
            '• You can reset your password anytime',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.blue,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
