import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Initializes Firebase if possible.
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
    return await Firebase.initializeApp();
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    return null;
  }
}
