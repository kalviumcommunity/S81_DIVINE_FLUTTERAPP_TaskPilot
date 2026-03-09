import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

/// Handles Firebase Cloud Messaging (FCM) setup, token retrieval, and message listening.
class FCMService {
  static final FCMService _instance = FCMService._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // Stream controllers for message streams
  final StreamController<RemoteMessage> _foregroundMessageController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> _notificationTapController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<String> _tokenRefreshController =
      StreamController<String>.broadcast();
  final StreamController<String> _logController =
      StreamController<String>.broadcast();

  String? _deviceToken;
  bool _isInitialized = false;
  final List<String> _logs = [];

  factory FCMService() {
    return _instance;
  }

  FCMService._internal();

  /// Initialize FCM service with permission handling and message listeners
  Future<void> initialize() async {
    if (_isInitialized) {
      _addLog('FCM already initialized');
      return;
    }

    try {
      _addLog('Initializing FCM...');

      // Request notification permissions
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      _addLog('Notification permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus != AuthorizationStatus.denied) {
        // Get device token
        _deviceToken = await _firebaseMessaging.getToken();
        _addLog('Device Token: $_deviceToken');

        // Listen for token refresh
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          _deviceToken = newToken;
          _addLog('Token Refreshed: $newToken');
          _tokenRefreshController.add(newToken);
        });

        // Handle foreground messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _addLog('Foreground message received: ${message.notification?.title}');
          _foregroundMessageController.add(message);
        });

        // Handle notification tap when app is in background
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          _addLog('Notification tapped (from background): ${message.notification?.title}');
          _notificationTapController.add(message);
        });

        // Handle background messages
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        _isInitialized = true;
        _addLog('FCM initialization completed successfully');
      } else {
        _addLog('ERROR: Notification permissions denied');
      }
    } catch (e) {
      _addLog('ERROR: FCM initialization failed: $e');
      rethrow;
    }
  }

  /// Get the current device token
  String? getDeviceToken() => _deviceToken;

  /// Get device token as Future
  Future<String?> getDeviceTokenAsync() async {
    if (_deviceToken != null) {
      return _deviceToken;
    }
    try {
      _deviceToken = await _firebaseMessaging.getToken();
      _addLog('Retrieved device token: $_deviceToken');
      return _deviceToken;
    } catch (e) {
      _addLog('ERROR: Failed to get device token: $e');
      return null;
    }
  }

  /// Delete the current device token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _deviceToken = null;
      _addLog('Device token deleted');
    } catch (e) {
      _addLog('ERROR: Failed to delete token: $e');
      rethrow;
    }
  }

  /// Stream of foreground messages
  Stream<RemoteMessage> get foregroundMessageStream =>
      _foregroundMessageController.stream;

  /// Stream of notification taps
  Stream<RemoteMessage> get notificationTapStream =>
      _notificationTapController.stream;

  /// Stream of token refreshes
  Stream<String> get tokenRefreshStream => _tokenRefreshController.stream;

  /// Stream of log messages
  Stream<String> get logStream => _logController.stream;

  /// Get all logs
  List<String> getLogs() => List.from(_logs);

  /// Clear logs
  void clearLogs() {
    _logs.clear();
    _addLog('Logs cleared');
  }

  /// Check if FCM is initialized
  bool isInitialized() => _isInitialized;

  /// Add a log message
  void _addLog(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] $message';
    _logs.add(logMessage);
    _logController.add(logMessage);
    if (kDebugMode) {
      print('FCMService: $logMessage');
    }
  }

  /// Dispose resources
  void dispose() {
    _foregroundMessageController.close();
    _notificationTapController.close();
    _tokenRefreshController.close();
    _logController.close();
  }
}
