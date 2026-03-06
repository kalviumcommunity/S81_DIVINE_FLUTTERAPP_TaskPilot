import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';

/// Cloud Functions Documentation Screen
///
/// Comprehensive educational guide for Firebase Cloud Functions.
/// Covers callable functions, event-based triggers, and best practices.
class CloudFunctionsDocumentationScreen extends StatelessWidget {
  const CloudFunctionsDocumentationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Functions Guide'),
        backgroundColor: Colors.black87,
        foregroundColor: RetroColors.neonCyan,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black87,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // What are Cloud Functions?
              _buildSection(
                title: 'What Are Cloud Functions?',
                color: const Color(0xFF003D82),
                borderColor: RetroColors.neonCyan,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Serverless backend code that runs in Google Cloud without managing servers.\n',
                      style: TextStyle(color: Colors.white70),
                    ),
                    _buildBulletPoint('Write code, deploy, done - no infrastructure'),
                    _buildBulletPoint('Automatically scales from 1 to millions of calls'),
                    _buildBulletPoint('Pay per function call (free tier: 2M calls/month)'),
                    _buildBulletPoint('Integrates seamlessly with Firebase services'),
                    _buildBulletPoint('Run backend logic securely'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Types of Cloud Functions
              _buildSection(
                title: 'Two Types of Cloud Functions',
                color: const Color(0xFF1a5f3a),
                borderColor: RetroColors.neonGreen,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionSubheading('1. Callable Functions'),
                    _buildBulletPoint('Called directly from Flutter app'),
                    _buildBulletPoint('Request-response pattern'),
                    _buildBulletPoint('Can return data to app'),
                    const SizedBox(height: 12),
                    _buildCodeBlock('''// Flutter: Call function
final result = await CloudFunctionsService()
  .sayHello(name: 'Alex');
print(result); // Response: Hello, Alex!'''),
                    const SizedBox(height: 16),
                    _buildSectionSubheading('2. Event-Based Functions'),
                    _buildBulletPoint('Triggered automatically by Firebase events'),
                    _buildBulletPoint('No app call needed - runs in background'),
                    _buildBulletPoint('Triggers: Firestore, Auth, Storage, Pub/Sub'),
                    const SizedBox(height: 12),
                    _buildCodeBlock('''// Cloud Function: Triggered on user create
exports.onUserCreate = functions.auth
  .user().onCreate((user) => {
    // Send welcome email automatically
  });'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Setting Up Cloud Functions
              _buildSection(
                title: 'Setting Up Cloud Functions',
                color: const Color(0xFF4a2c5e),
                borderColor: RetroColors.neonMagenta,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNumberedStep('1', 'Install Firebase CLI',
                        'npm install -g firebase-tools'),
                    const SizedBox(height: 12),
                    _buildNumberedStep('2', 'Login to Firebase',
                        'firebase login'),
                    const SizedBox(height: 12),
                    _buildNumberedStep('3', 'Initialize Functions',
                        'firebase init functions'),
                    const SizedBox(height: 12),
                    _buildNumberedStep('4', 'Choose JavaScript or TypeScript',
                        'TypeScript recommended for better features'),
                    const SizedBox(height: 12),
                    _buildNumberedStep('5', 'Deploy Functions',
                        'firebase deploy --only functions'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Creating Callable Functions
              _buildSection(
                title: 'Creating Callable Functions',
                color: const Color(0xFF5c3a00),
                borderColor: RetroColors.neonOrange,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'In functions/index.js:\n',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCodeBlock('''exports.sayHello = functions.https
  .onCall((data, context) => {
    // data: input from Flutter app
    // context: user auth info
    
    const name = data.name || "User";
    return { 
      message: \`Hello, \${name}!\` 
    };
  });'''),
                    const SizedBox(height: 12),
                    const Text(
                      'Key Points:',
                      style: TextStyle(
                        color: RetroColors.neonOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint('onCall() = callable function'),
                    _buildBulletPoint('data = parameters from app'),
                    _buildBulletPoint('context.auth = authenticated user info'),
                    _buildBulletPoint('Return object = response to app'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Event-Based Functions
              _buildSection(
                title: 'Event-Based Functions',
                color: const Color(0xFF1a4d3a),
                borderColor: RetroColors.neonGreen,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionSubheading('Firestore Triggers'),
                    _buildCodeBlock('''exports.onUserCreate = functions.firestore
  .document("users/{userId}")
  .onCreate((snap, context) => {
    const userData = snap.data();
    console.log("New user:", userData);
    // Send welcome email
    // Create user profile
  });'''),
                    const SizedBox(height: 12),
                    _buildSectionSubheading('Auth Triggers'),
                    _buildCodeBlock('''exports.sendWelcomeEmail = functions.auth
  .user().onCreate((user) => {
    const email = user.email;
    const uid = user.uid;
    // Send welcome email on signup
  });'''),
                    const SizedBox(height: 12),
                    _buildSectionSubheading('Storage Triggers'),
                    _buildCodeBlock('''exports.generateThumbnail = functions.storage
  .object()
  .onFinalize(async (object) => {
    // File upload complete
    // Generate thumbnail, process image
  });'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Calling from Flutter
              _buildSection(
                title: 'Calling functions from Flutter',
                color: const Color(0xFF003d6b),
                borderColor: RetroColors.neonCyan,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Simple Call:\n',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCodeBlock('''final service = CloudFunctionsService();
final result = await service.sayHello(
  name: 'Alex'
);
print(result); // Hello, Alex!'''),
                    const SizedBox(height: 12),
                    const Text(
                      'With Error Handling:\n',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCodeBlock('''try {
  final result = await service.sayHello();
} on FirebaseFunctionsException catch (e) {
  // Cloud Function error
  String msg = service.getErrorMessage(e);
  print(msg); // User-friendly message
}'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Security Best Practices
              _buildSection(
                title: 'Security Best Practices',
                color: const Color(0xFF5c2020),
                borderColor: Colors.red,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBulletPoint('Authenticate users before calling functions'),
                    _buildBulletPoint('Validate input server-side - never trust app'),
                    _buildBulletPoint('Use environment variables for secrets'),
                    _buildBulletPoint('Set proper function memory/timeout limits'),
                    _buildBulletPoint('Log important operations for audit trail'),
                    _buildBulletPoint('Rate-limit function calls if needed'),
                    _buildBulletPoint('Never expose API keys or credentials'),
                    const SizedBox(height: 12),
                    const Text(
                      'Example - Validate Server-Side:',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCodeBlock('''exports.processPayment = functions.https
  .onCall((data, context) => {
    // Check authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Must be logged in'
      );
    }
    
    // Validate input
    if (!data.amount || data.amount <= 0) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Amount must be positive'
      );
    }
  });'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Pricing
              _buildSection(
                title: 'Cloud Functions Pricing',
                color: const Color(0xFF1a5f3a),
                borderColor: RetroColors.neonGreen,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBulletPoint('First 2 million calls/month: FREE'),
                    _buildBulletPoint('Additional calls: \$0.40 per million'),
                    _buildBulletPoint('Compute time: \$0.000002400 per GB-second'),
                    _buildBulletPoint('Data transfer: Variable (first 5GB free)'),
                    const SizedBox(height: 12),
                    const Text(
                      'Example Cost:',
                      style: TextStyle(
                        color: RetroColors.neonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint('10 million calls/month = 8M over free = ~\$3.20'),
                    _buildBulletPoint('Simple functions are very cheap!'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Common Use Cases
              _buildSection(
                title: 'Common Use Cases',
                color: const Color(0xFF4a2c5e),
                borderColor: RetroColors.neonMagenta,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUseCase(
                      'Send Notifications',
                      'Email, SMS, push notifications',
                    ),
                    _buildUseCase(
                      'Validate Input',
                      'Server-side validation, duplicate checks',
                    ),
                    _buildUseCase(
                      'Process Payments',
                      'Stripe/PayPal integration securely',
                    ),
                    _buildUseCase(
                      'Generate Documents',
                      'PDFs, invoices, reports',
                    ),
                    _buildUseCase(
                      'Data Aggregation',
                      'Calculate stats from Firestore',
                    ),
                    _buildUseCase(
                      'Scheduled Tasks',
                      'Pub/Sub triggers, daily jobs',
                    ),
                    _buildUseCase(
                      'ML Processing',
                      'Run ML models, image recognition',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Debugging
              _buildSection(
                title: 'Debugging & Monitoring',
                color: const Color(0xFF5c3a00),
                borderColor: RetroColors.neonOrange,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionSubheading('View Logs:'),
                    _buildBulletPoint(
                        'Firebase Console → Functions → Logs'),
                    _buildBulletPoint(
                        'See all function executions and errors'),
                    _buildBulletPoint('Filter by function, time, status'),
                    const SizedBox(height: 12),
                    _buildSectionSubheading('Debug Locally:'),
                    _buildCodeBlock('''firebase emulators:start --only functions
# Run functions locally for testing'''),
                    const SizedBox(height: 12),
                    _buildSectionSubheading('Test Functions:'),
                    _buildCodeBlock('''firebase functions:shell
# Interactive shell to test functions
# > sayHello({name: 'Test'})'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Best Practices
              _buildSection(
                title: 'Best Practices',
                color: const Color(0xFF1a4d3a),
                borderColor: RetroColors.neonGreen,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBulletPoint('Keep functions small and focused'),
                    _buildBulletPoint('Use TypeScript for type safety'),
                    _buildBulletPoint('Handle all errors gracefully'),
                    _buildBulletPoint('Log important operations'),
                    _buildBulletPoint('Test locally with emulator'),
                    _buildBulletPoint('Set appropriate timeouts'),
                    _buildBulletPoint('Use environment variables for config'),
                    _buildBulletPoint('Monitor execution time and cost'),
                    _buildBulletPoint('Version your functions'),
                    _buildBulletPoint('Document function behavior'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Build section with colored background
  Widget _buildSection({
    required String title,
    required Color color,
    required Color borderColor,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: borderColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: content,
          ),
        ],
      ),
    );
  }

  /// Build bullet point
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  /// Build section subheading
  Widget _buildSectionSubheading(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  /// Build numbered step
  Widget _buildNumberedStep(String number, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              number,
              style: const TextStyle(
                color: RetroColors.neonGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  /// Build code block
  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0a0a0a),
        border: Border.all(color: Colors.grey.shade700, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          color: RetroColors.neonGreen,
          fontSize: 10,
          fontFamily: 'monospace',
          height: 1.5,
        ),
      ),
    );
  }

  /// Build use case
  Widget _buildUseCase(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: RetroColors.neonGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
