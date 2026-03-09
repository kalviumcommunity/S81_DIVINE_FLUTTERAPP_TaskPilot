import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/fcm_service.dart';
import '../constants/retro_theme.dart';

class FCMDemoScreen extends StatefulWidget {
  const FCMDemoScreen({Key? key}) : super(key: key);

  @override
  State<FCMDemoScreen> createState() => _FCMDemoScreenState();
}

class _FCMDemoScreenState extends State<FCMDemoScreen> {
  final FCMService _fcmService = FCMService();
  bool _isInitialized = false;
  String? _deviceToken;
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _initializeFCM();
    _subscribeTologs();
  }

  Future<void> _initializeFCM() async {
    try {
      if (!_fcmService.isInitialized()) {
        await _fcmService.initialize();
      }
      _deviceToken = _fcmService.getDeviceToken();
      setState(() {
        _isInitialized = true;
        _logs = _fcmService.getLogs();
      });
    } catch (e) {
      setState(() {
        _logs.add('ERROR: Failed to initialize FCM: $e');
      });
    }
  }

  void _subscribeTologs() {
    _fcmService.logStream.listen((log) {
      setState(() {
        _logs.add(log);
        // Keep only last 100 logs for performance
        if (_logs.length > 100) {
          _logs.removeAt(0);
        }
      });
    });

    _fcmService.notificationTapStream.listen((RemoteMessage message) {
      _showMessageDialog('Notification Tapped', message);
    });

    _fcmService.foregroundMessageStream.listen((RemoteMessage message) {
      _showMessageDialog('Foreground Message', message);
    });
  }

  void _showMessageDialog(String title, RemoteMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.notification != null) ...[
                Text('Title: ${message.notification!.title}'),
                const SizedBox(height: 8),
                Text('Body: ${message.notification!.body}'),
                const SizedBox(height: 8),
              ],
              if (message.data.isNotEmpty) ...[
                const Text('Data:'),
                ...message.data.entries.map((e) => Text('${e.key}: ${e.value}')),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshToken() async {
    try {
      final token = await _fcmService.getDeviceTokenAsync();
      setState(() {
        _deviceToken = token;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token refreshed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to refresh token: $e')),
        );
      }
    }
  }

  Future<void> _deleteToken() async {
    try {
      await _fcmService.deleteToken();
      setState(() {
        _deviceToken = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete token: $e')),
        );
      }
    }
  }

  void _clearLogs() {
    _fcmService.clearLogs();
    setState(() {
      _logs.clear();
    });
  }

  void _copyTokenToClipboard() {
    if (_deviceToken != null) {
      Clipboard.setData(ClipboardData(text: _deviceToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Cloud Messaging Demo'),
        backgroundColor: RetroColors.neonPurple,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // FCM Status Card
              Card(
                elevation: 4,
                color: _isInitialized ? Colors.green[50] : Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isInitialized ? Icons.check_circle : Icons.error,
                            color: _isInitialized ? Colors.green : Colors.red,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _isInitialized ? 'FCM Initialized' : 'FCM Not Initialized',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _isInitialized ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Device Token:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          _deviceToken ?? 'No token available',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: _copyTokenToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Token'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroColors.neonPurple,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _refreshToken,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Token'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _deleteToken,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Token'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _clearLogs,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Logs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Logs Section
              Text(
                'FCM Activity Logs (${_logs.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[50],
                ),
                child: _logs.isEmpty
                    ? const Center(
                      child: Text('No logs yet. Initializing FCM...'),
                    )
                    : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _logs[index],
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
              ),
              const SizedBox(height: 16),

              // Instructions
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to Test Push Notifications:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('1. Copy your device token from above'),
                      const Text('2. Go to Firebase Console > Cloud Messaging'),
                      const Text('3. Create a new campaign and send to this device'),
                      const Text('4. Watch the logs update in real-time'),
                      const Text('5. Tap on notifications to see details'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
