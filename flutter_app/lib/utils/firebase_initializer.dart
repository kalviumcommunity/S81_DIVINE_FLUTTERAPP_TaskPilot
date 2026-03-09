import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';
import '../services/fcm_service.dart';

/// Initializes Firebase and FCM if possible.
///
/// Returns the initialized [FirebaseApp] when successful, otherwise returns null.
///
/// This is intentionally defensive so the app can still run even when
/// `google-services.json` / `GoogleService-Info.plist` are not added yet.
Future<FirebaseApp?> initializeFirebaseSafely() async {
  try {
    if (Firebase.apps.isNotEmpty) {
      return Firebase.apps.first;
    }
    final firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize FCM for push notifications
    try {
      await FCMService().initialize();
    } catch (e) {
      debugPrint('FCM initialization failed: $e');
      // Continue app execution even if FCM fails
    }

    return firebaseApp;
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    return null;
  }
}
