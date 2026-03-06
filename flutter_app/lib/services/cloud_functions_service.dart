import 'package:cloud_functions/cloud_functions.dart';

/// Cloud Functions Service
///
/// Singleton service for invoking Firebase Cloud Functions from Flutter.
/// Supports both callable functions (called from app) and event-triggered functions
/// (triggered by Firestore events, Auth events, etc.).
class CloudFunctionsService {
  static final CloudFunctionsService _instance =
      CloudFunctionsService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  CloudFunctionsService._internal();

  factory CloudFunctionsService() {
    return _instance;
  }

  // GREETING FUNCTIONS

  /// Basic greeting function
  ///
  /// Demonstrates simple callable function
  /// Parameters: name (optional)
  /// Returns: greeting message
  Future<String> sayHello({String name = 'User'}) async {
    try {
      final callable = _functions.httpsCallable('sayHello');
      final result = await callable.call({'name': name});
      return result.data['message'] ?? 'Hello!';
    } catch (e) {
      throw Exception('Say hello failed: $e');
    }
  }

  // NOTIFICATION FUNCTIONS

  /// Send notification to user
  ///
  /// Triggers notification via Cloud Function
  /// Handles email or push notification sending
  Future<Map<String, dynamic>> sendNotification({
    required String userId,
    required String title,
    required String message,
    String? email,
  }) async {
    try {
      final callable = _functions.httpsCallable('sendNotification');
      final result = await callable.call({
        'userId': userId,
        'title': title,
        'message': message,
        'email': email,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Send notification failed: $e');
    }
  }

  /// Send welcome email
  ///
  /// Called when new user signs up
  /// Sends personalized welcome email via Cloud Function
  Future<Map<String, dynamic>> sendWelcomeEmail({
    required String userId,
    required String email,
    required String displayName,
  }) async {
    try {
      final callable = _functions.httpsCallable('sendWelcomeEmail');
      final result = await callable.call({
        'userId': userId,
        'email': email,
        'displayName': displayName,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Send welcome email failed: $e');
    }
  }

  // DATA PROCESSING FUNCTIONS

  /// Generate invoice PDF
  ///
  /// Cloud Function generates invoice and returns download URL
  Future<String> generateInvoice({
    required String invoiceId,
    required String userId,
    required double amount,
    required String clientName,
  }) async {
    try {
      final callable = _functions.httpsCallable('generateInvoice');
      final result = await callable.call({
        'invoiceId': invoiceId,
        'userId': userId,
        'amount': amount,
        'clientName': clientName,
      });
      return result.data['pdfUrl'] ?? '';
    } catch (e) {
      throw Exception('Generate invoice failed: $e');
    }
  }

  /// Process payment via Stripe
  ///
  /// Securely processes payment using Cloud Function
  /// Never send card data directly from app - use Cloud Function
  Future<Map<String, dynamic>> processPayment({
    required String userId,
    required double amount,
    required String currency,
    String? description,
  }) async {
    try {
      final callable = _functions.httpsCallable('processPayment');
      final result = await callable.call({
        'userId': userId,
        'amount': amount,
        'currency': currency,
        'description': description,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Process payment failed: $e');
    }
  }

  /// Aggregate user statistics
  ///
  /// Cloud Function calculates stats from Firestore
  /// Returns user metrics: total tasks, completed, summary stats
  Future<Map<String, dynamic>> getUserStatistics({
    required String userId,
  }) async {
    try {
      final callable = _functions.httpsCallable('getUserStatistics');
      final result = await callable.call({
        'userId': userId,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Get user statistics failed: $e');
    }
  }

  /// Bulk update user data
  ///
  /// Cloud Function updates multiple documents atomically
  /// More reliable than looping updates in Flutter app
  Future<Map<String, dynamic>> bulkUpdateTasks({
    required String userId,
    required List<String> taskIds,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final callable = _functions.httpsCallable('bulkUpdateTasks');
      final result = await callable.call({
        'userId': userId,
        'taskIds': taskIds,
        'updates': updates,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Bulk update failed: $e');
    }
  }

  // DATA VALIDATION FUNCTIONS

  /// Validate email
  ///
  /// Server-side validation for email availability
  /// Prevents duplicate registrations
  Future<bool> validateEmail(String email) async {
    try {
      final callable = _functions.httpsCallable('validateEmail');
      final result = await callable.call({'email': email});
      return result.data['isValid'] as bool;
    } catch (e) {
      throw Exception('Email validation failed: $e');
    }
  }

  /// Validate username availability
  ///
  /// Checks if username is available and meets criteria
  Future<Map<String, dynamic>> validateUsername(String username) async {
    try {
      final callable = _functions.httpsCallable('validateUsername');
      final result = await callable.call({'username': username});
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Username validation failed: $e');
    }
  }

  // CLEANUP FUNCTIONS

  /// Delete user account and all associated data
  ///
  /// Cloud Function securely deletes user data across all collections
  /// More reliable than deleting from app
  Future<Map<String, dynamic>> deleteUserAccount({
    required String userId,
    String? reason,
  }) async {
    try {
      final callable = _functions.httpsCallable('deleteUserAccount');
      final result = await callable.call({
        'userId': userId,
        'reason': reason,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Delete account failed: $e');
    }
  }

  /// Archive old user data
  ///
  /// Moves completed tasks and old records to archive collection
  Future<Map<String, dynamic>> archiveOldData({
    required String userId,
    required int daysOld,
  }) async {
    try {
      final callable = _functions.httpsCallable('archiveOldData');
      final result = await callable.call({
        'userId': userId,
        'daysOld': daysOld,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Archive data failed: $e');
    }
  }

  // AI/ML FUNCTIONS

  /// Generate task summary using AI
  ///
  /// Cloud Function uses AI to analyze and summarize tasks
  Future<String> generateTaskSummary({
    required String userId,
    int maxTasks = 10,
  }) async {
    try {
      final callable = _functions.httpsCallable('generateTaskSummary');
      final result = await callable.call({
        'userId': userId,
        'maxTasks': maxTasks,
      });
      return result.data['summary'] ?? '';
    } catch (e) {
      throw Exception('Generate summary failed: $e');
    }
  }

  /// Suggest next task based on AI analysis
  ///
  /// Cloud Function analyzes user's tasks and suggests next action
  Future<Map<String, dynamic>> suggestNextTask({
    required String userId,
  }) async {
    try {
      final callable = _functions.httpsCallable('suggestNextTask');
      final result = await callable.call({
        'userId': userId,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Suggest next task failed: $e');
    }
  }

  // SCHEDULING FUNCTIONS

  /// Schedule task reminder
  ///
  /// Cloud Function schedules a notification for future time
  Future<Map<String, dynamic>> scheduleReminder({
    required String userId,
    required String taskId,
    required DateTime reminderTime,
    String? message,
  }) async {
    try {
      final callable = _functions.httpsCallable('scheduleReminder');
      final result = await callable.call({
        'userId': userId,
        'taskId': taskId,
        'reminderTime': reminderTime.toIso8601String(),
        'message': message,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Schedule reminder failed: $e');
    }
  }

  /// Send daily digest email
  ///
  /// Cloud Function sends summary of user's daily tasks
  Future<Map<String, dynamic>> sendDailyDigest({
    required String userId,
  }) async {
    try {
      final callable = _functions.httpsCallable('sendDailyDigest');
      final result = await callable.call({
        'userId': userId,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Send daily digest failed: $e');
    }
  }

  // UTILITY FUNCTIONS

  /// Get server timestamp
  ///
  /// Get current server time for sync
  Future<DateTime> getServerTime() async {
    try {
      final callable = _functions.httpsCallable('getServerTime');
      final result = await callable.call();
      final timestamp = result.data['timestamp'];
      if (timestamp is num) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
      }
      return DateTime.now();
    } catch (e) {
      throw Exception('Get server time failed: $e');
    }
  }

  /// Health check - verify Cloud Functions are running
  ///
  /// Returns status and available functions
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final callable = _functions.httpsCallable('healthCheck');
      final result = await callable.call();
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Health check failed: $e');
    }
  }

  /// Get app config from Cloud Function
  ///
  /// Centralized configuration management
  Future<Map<String, dynamic>> getAppConfig() async {
    try {
      final callable = _functions.httpsCallable('getAppConfig');
      final result = await callable.call();
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      throw Exception('Get app config failed: $e');
    }
  }

  // ERROR HANDLING HELPERS

  /// Handle Cloud Function errors
  ///
  /// Translates Cloud Function errors to user-friendly messages
  String getErrorMessage(dynamic error) {
    if (error is FirebaseFunctionsException) {
      switch (error.code) {
        case 'unauthenticated':
          return 'User not authenticated. Please sign in.';
        case 'unauthorized':
          return 'You do not have permission for this action.';
        case 'not-found':
          return 'Function or resource not found.';
        case 'invalid-argument':
          return 'Invalid parameters provided.';
        case 'internal':
          return 'Server error. Please try again later.';
        case 'resource-exhausted':
          return 'Too many requests. Please wait and try again.';
        case 'deadline-exceeded':
          return 'Request took too long. Please try again.';
        default:
          return 'Error: ${error.message}';
      }
    }
    return 'An unexpected error occurred: $error';
  }

  /// Check if function is available
  ///
  /// Verify function exists before calling
  Future<bool> isFunctionAvailable(String functionName) async {
    try {
      final result = await healthCheck();
      final functions = result['availableFunctions'] as List? ?? [];
      return functions.contains(functionName);
    } catch (e) {
      return false;
    }
  }

  /// Retry function call with exponential backoff
  ///
  /// Automatically retries on timeout/network errors
  Future<T> callWithRetry<T>(
    Future<T> Function() call, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxRetries) {
      try {
        return await call();
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) rethrow;

        // Only retry on certain errors
        if (e is FirebaseFunctionsException) {
          if (e.code != 'deadline-exceeded' &&
              e.code != 'resource-exhausted') {
            rethrow;
          }
        }

        // Wait before retry
        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      }
    }

    throw Exception('Max retries exceeded');
  }

  /// Get raw Firebase Functions instance for advanced operations
  FirebaseFunctions getFirebaseFunctionsInstance() {
    return _functions;
  }
}
