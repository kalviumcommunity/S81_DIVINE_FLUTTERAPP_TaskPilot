import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore Service
/// Handles CRUD operations for tasks, clients, and payments
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== TASKS ====================

  /// Add a new task
  Future<String?> addTask(String userId, Map<String, dynamic> taskData) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .add({
        ...taskData,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      return docRef.id;
    } catch (e) {
      print('Error adding task: $e');
      return null;
    }
  }

  /// Get all tasks for user (paginated)
  Future<List<Map<String, dynamic>>> getTasks(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .orderBy('deadline', descending: false)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  /// Get tasks stream (real-time)
  Stream<List<Map<String, dynamic>>> getTasksStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('deadline', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  /// Get tasks by status stream
  Stream<List<Map<String, dynamic>>> getTasksByStatusStream(
    String userId,
    String status,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('status', isEqualTo: status)
        .orderBy('deadline', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  /// Update task
  Future<void> updateTask(
    String userId,
    String taskId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = DateTime.now();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .update(updates);
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  /// Delete task
  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  /// Get single task
  Future<Map<String, dynamic>?> getTask(String userId, String taskId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .get();

      if (doc.exists) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }
      return null;
    } catch (e) {
      print('Error fetching task: $e');
      return null;
    }
  }

  // ==================== CLIENTS ====================

  /// Add a new client
  Future<String?> addClient(String userId, Map<String, dynamic> clientData) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('clients')
          .add({
        ...clientData,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      return docRef.id;
    } catch (e) {
      print('Error adding client: $e');
      return null;
    }
  }

  /// Get all clients for user
  Stream<List<Map<String, dynamic>>> getClientsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('clients')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  /// Update client
  Future<void> updateClient(
    String userId,
    String clientId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = DateTime.now();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('clients')
          .doc(clientId)
          .update(updates);
    } catch (e) {
      print('Error updating client: $e');
    }
  }

  /// Delete client
  Future<void> deleteClient(String userId, String clientId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('clients')
          .doc(clientId)
          .delete();
    } catch (e) {
      print('Error deleting client: $e');
    }
  }

  // ==================== PAYMENTS ====================

  /// Add a new payment record
  Future<String?> addPayment(String userId, Map<String, dynamic> paymentData) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .add({
        ...paymentData,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      return docRef.id;
    } catch (e) {
      print('Error adding payment: $e');
      return null;
    }
  }

  /// Get payments stream (real-time)
  Stream<List<Map<String, dynamic>>> getPaymentsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('payments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  /// Get unpaid payments stream
  Stream<List<Map<String, dynamic>>> getUnpaidPaymentsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('payments')
        .where('status', isEqualTo: 'unpaid')
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  /// Update payment
  Future<void> updatePayment(
    String userId,
    String paymentId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = DateTime.now();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc(paymentId)
          .update(updates);
    } catch (e) {
      print('Error updating payment: $e');
    }
  }

  /// Delete payment
  Future<void> deletePayment(String userId, String paymentId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc(paymentId)
          .delete();
    } catch (e) {
      print('Error deleting payment: $e');
    }
  }

  // ==================== DASHBOARD STATS ====================

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats(String userId) async {
    try {
      final tasksSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .get();

      final paymentsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .get();

      final clientsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('clients')
          .get();

      final activeTasks = tasksSnapshot.docs
          .where((doc) => doc['status'] != 'done')
          .length;

      final totalTasks = tasksSnapshot.docs.length;

      final unpaidAmount = paymentsSnapshot.docs
          .where((doc) => doc['status'] == 'unpaid')
          .fold<double>(0, (sum, doc) => sum + (doc['amount'] ?? 0).toDouble());

      final completionRate = totalTasks > 0
          ? ((totalTasks - activeTasks) / totalTasks * 100).toStringAsFixed(0)
          : '0';

      return {
        'activeTasks': activeTasks,
        'totalTasks': totalTasks,
        'unpaidAmount': unpaidAmount.toStringAsFixed(2),
        'completionRate': completionRate,
        'totalClients': clientsSnapshot.docs.length,
      };
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return {};
    }
  }

  // ==================== BATCH OPERATIONS ====================

  /// Batch delete all tasks (with caution)
  Future<void> deleteAllTasks(String userId) async {
    try {
      final tasks = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .get();

      for (var doc in tasks.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting all tasks: $e');
    }
  }

  /// Batch update tasks status
  Future<void> updateTasksStatus(
    String userId,
    List<String> taskIds,
    String newStatus,
  ) async {
    try {
      final batch = _firestore.batch();

      for (var taskId in taskIds) {
        final ref = _firestore
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .doc(taskId);

        batch.update(ref, {
          'status': newStatus,
          'updatedAt': DateTime.now(),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error batch updating tasks: $e');
    }
  }
}
