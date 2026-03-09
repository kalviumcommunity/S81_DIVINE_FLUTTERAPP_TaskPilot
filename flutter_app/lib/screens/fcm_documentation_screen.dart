import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';

class FCMDocumentationScreen extends StatelessWidget {
  const FCMDocumentationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Implementation Guide'),
        backgroundColor: RetroColors.neonPurple,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'Overview',
              'Firebase Cloud Messaging (FCM) enables reliable delivery of push notifications to Flutter applications across iOS and Android platforms.',
            ),
            _buildSection(
              context,
              'Architecture',
              '''The FCM integration consists of:
• FCMService: Singleton service managing initialization, permissions, and message listeners
• Message Streams: Real-time streams for foreground messages, notification taps, and token refreshes
• Device Token Management: Secure device token retrieval and management
• Permission Handling: Platform-specific permission requests and status tracking
• Log System: Comprehensive logging for debugging and monitoring''',
            ),
            _buildSection(
              context,
              'Key Components',
              '''1. FCMService (services/fcm_service.dart)
   - Singleton pattern for app-wide access
   - Initializes messaging with permission requests
   - Manages foreground message listeners
   - Handles notification tap events
   - Tracks token refresh events
   - Provides real-time log streams

2. FCMDemoScreen (screens/fcm_demo_screen.dart)
   - Display device token
   - Copy token to clipboard
   - Manage tokens (refresh/delete)
   - View real-time activity logs
   - Instructions for testing

3. Firebase Initialization (utils/firebase_initializer.dart)
   - Initializes Firebase Core
   - Sets up FCM during app startup
   - Graceful error handling''',
            ),
            _buildSection(
              context,
              'Permission Handling',
              '''Android 13+:
• POST_NOTIFICATIONS permission required for visible notifications
• Permission request in FCMService.initialize()
• User can grant/deny notification access

iOS:
• User Alert permission automatically requested
• Provisional authorization for quiet notifications
• No manual config needed - firebase_messaging handles it''',
            ),
            _buildSection(
              context,
              'Message Listeners',
              '''1. Foreground Messages (App Open):
   - Caught by FirebaseMessaging.onMessage listener
   - Display with optional notification UI
   - Access message title, body, and custom data

2. Background Messages (App in Background):
   - Handled by setForegroundNotificationPresentationOptions
   - System notification shown with title and body
   - User can tap to open app

3. Notification Taps (All States):
   - Caught by FirebaseMessaging.onMessageOpenedApp listener
   - Triggered when user taps notification
   - Can route to specific screens based on message data

4. Termination:
   - Message handled when app is completely terminated
   - FirebaseMessaging.getInitialMessage() can check on startup''',
            ),
            _buildSection(
              context,
              'Device Token Management',
              '''Getting Token:
• Automatic: Retrieves on first app launch
• Manual: Call getDeviceTokenAsync() for fresh token
• Refresh: Automatically tracked via onTokenRefresh stream

Token Lifecycle:
• Fresh after app reinstall
• Can be deleted and regenerated
• Refresh tracking enables server-side token updates
• Send messages using tokens from Firebase Console

Sending Test Messages:
1. Copy device token from app
2. Go to Firebase Console > Cloud Messaging
3. Create new campaign
4. Select "Send to Device" and paste token
5. Monitor logs in real-time''',
            ),
            _buildSection(
              context,
              'Data Structures',
              '''RemoteMessage:
• notification: Title and body for system notification
• data: Custom key-value pairs for app logic
• from: Sender ID or topic
• sentTime: Message send timestamp
• ttl: Time to live in seconds

Example Handling:
```
_fcmService.foregroundMessageStream.listen((message) {
  final title = message.notification?.title;
  final body = message.notification?.body;
  final customData = message.data;
  
  // Show dialog or update UI
  _showMessageDialog(title, body, customData);
});
```''',
            ),
            _buildSection(
              context,
              'Configuration Files',
              '''Android (AndroidManifest.xml):
• android.permission.INTERNET
• android.permission.POST_NOTIFICATIONS
• Activity set as launchMode="singleTop"

iOS (Configured by firebase_messaging):
• No manual plist changes required
• Xcode auto-managed via Flutter plugin
• APNs certificate must be configured in Firebase Console

Firebase Project:
• Enable Cloud Messaging in Firebase Console
• Download google-services.json (Android)
• Download GoogleService-Info.plist (iOS)
• Configure APNs certificate for iOS''',
            ),
            _buildSection(
              context,
              'Best Practices',
              '''1. Token Management:
   - Request permission on app startup
   - Handle token refresh gracefully
   - Sync tokens to backend for messaging

2. Message Handling:
   - Validate data before processing
   - Handle all three states: foreground, background, tap
   - Update UI safely with setState

3. User Experience:
   - Request permissions at appropriate time
   - Show clear messaging about notification benefits
   - Respect user notification preferences

4. Security:
   - Validate tokens in backend
   - Verify message authenticity
   - Don't expose sensitive data in custom data payloads

5. Debugging:
   - Enable FCM logs in Firebase Console
   - Check app logs for detailed handler execution
   - Test across different app states''',
            ),
            _buildSection(
              context,
              'Common Issues',
              '''1. Notifications not received on Android 13+:
   - Ensure POST_NOTIFICATIONS permission is granted
   - Check notification settings in Settings app

2. Token not showing:
   - App must have notification permission
   - Check Firebase configuration files
   - Verify internet connection

3. Messages not delivered:
   - Check FCM metrics in Firebase Console
   - Verify token is current (not deleted)
   - Ensure APNs certificate configured for iOS

4. Permission dialog not showing:
   - Normal if user already denied (can be changed in settings)
   - Check app permissions in Settings app''',
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Start Checklist:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('✓ FCM service initialized'),
                    const Text('✓ Permissions requested on startup'),
                    const Text('✓ Device token retrieved'),
                    const Text('✓ Message listeners registered'),
                    const Text('✓ AndroidManifest.xml updated'),
                    const Text('✓ Firebase configuration verified'),
                    const Text('✓ Demo screen available at /fcm-demo'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: RetroColors.neonPurple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
