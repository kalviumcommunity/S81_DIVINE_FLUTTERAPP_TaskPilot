import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../models/project_model.dart';
import '../models/client_model.dart';

///
/// FirestoreService - Handles all read operations from Firestore
///
/// This service provides methods for:
/// - Reading collections with real-time updates (snapshots)
/// - Reading single documents
/// - Querying with filters
/// - Proper error handling and null safety
///
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  // ============================================================================
  // TASKS COLLECTION READS
  // ============================================================================

  /// Get all tasks for a user (real-time updates using snapshots)
  /// 
  /// Returns a Stream of task lists that updates whenever data changes in Firestore
  Stream<List<TaskModel>> getUserTasks(String userId) {
    try {
      return _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('dueDate', descending: false)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
                .toList();
          })
          .handleError((error) {
            print('Error reading user tasks: $error');
            return <TaskModel>[];
          });
    } catch (e) {
      print('Exception in getUserTasks: $e');
      return Stream.value([]);
    }
  }

  /// Get tasks for a specific project (real-time updates)
  Stream<List<TaskModel>> getProjectTasks(String projectId) {
    try {
      return _firestore
          .collection('tasks')
          .where('projectId', isEqualTo: projectId)
          .orderBy('priority', descending: true)
          .orderBy('dueDate', descending: false)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
                .toList();
          })
          .handleError((error) {
            print('Error reading project tasks: $error');
            return <TaskModel>[];
          });
    } catch (e) {
      print('Exception in getProjectTasks: $e');
      return Stream.value([]);
    }
  }

  /// Get a single task by ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final doc = await _firestore.collection('tasks').doc(taskId).get();
      if (doc.exists) {
        return TaskModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error reading task: $e');
      return null;
    }
  }

  /// Get tasks by status (e.g., 'pending', 'in_progress', 'completed')
  Stream<List<TaskModel>> getTasksByStatus(String userId, String status) {
    try {
      return _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
                .toList();
          })
          .handleError((error) {
            print('Error reading tasks by status: $error');
            return <TaskModel>[];
          });
    } catch (e) {
      print('Exception in getTasksByStatus: $e');
      return Stream.value([]);
    }
  }

  /// Get overdue tasks for a user
  Future<List<TaskModel>> getOverdueTasks(String userId) async {
    try {
      final now = DateTime.now();
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('status', isNotEqualTo: 'completed')
          .get();

      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
          .where((task) => task.dueDate.isBefore(now))
          .toList();
    } catch (e) {
      print('Error reading overdue tasks: $e');
      return [];
    }
  }

  // ============================================================================
  // PROJECTS COLLECTION READS
  // ============================================================================

  /// Get all projects for a user (real-time updates)
  Stream<List<ProjectModel>> getUserProjects(String userId) {
    try {
      return _firestore
          .collection('projects')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ProjectModel.fromFirestore(doc.data(), doc.id))
                .toList();
          })
          .handleError((error) {
            print('Error reading user projects: $error');
            return <ProjectModel>[];
          });
    } catch (e) {
      print('Exception in getUserProjects: $e');
      return Stream.value([]);
    }
  }

  /// Get projects for a specific client
  Stream<List<ProjectModel>> getClientProjects(String clientId) {
    try {
      return _firestore
          .collection('projects')
          .where('clientId', isEqualTo: clientId)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ProjectModel.fromFirestore(doc.data(), doc.id))
                .toList();
          })
          .handleError((error) {
            print('Error reading client projects: $error');
            return <ProjectModel>[];
          });
    } catch (e) {
      print('Exception in getClientProjects: $e');
      return Stream.value([]);
    }
  }

  /// Get a single project by ID
  Future<ProjectModel?> getProjectById(String projectId) async {
    try {
      final doc =
          await _firestore.collection('projects').doc(projectId).get();
      if (doc.exists) {
        return ProjectModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error reading project: $e');
      return null;
    }
  }

  /// Get projects by status
  Stream<List<ProjectModel>> getProjectsByStatus(String userId, String status) {
    try {
      return _firestore
          .collection('projects')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ProjectModel.fromFirestore(doc.data(), doc.id))
                .toList();
          })
          .handleError((error) {
            print('Error reading projects by status: $error');
            return <ProjectModel>[];
          });
    } catch (e) {
      print('Exception in getProjectsByStatus: $e');
      return Stream.value([]);
    }
  }

  // ============================================================================
  // CLIENTS COLLECTION READS
  // ============================================================================

  /// Get all clients for a user (real-time updates)
  Stream<List<ClientModel>> getUserClients(String userId) {
    try {
      return _firestore
          .collection('clients')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('isActive', descending: true)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ClientModel.fromFirestore(doc.data(), doc.id))
                .toList();
          })
          .handleError((error) {
            print('Error reading user clients: $error');
            return <ClientModel>[];
          });
    } catch (e) {
      print('Exception in getUserClients: $e');
      return Stream.value([]);
    }
  }

  /// Get a single client by ID
  Future<ClientModel?> getClientById(String clientId) async {
    try {
      final doc = await _firestore.collection('clients').doc(clientId).get();
      if (doc.exists) {
        return ClientModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error reading client: $e');
      return null;
    }
  }

  /// Get all clients (including inactive) for a user
  Stream<List<ClientModel>> getAllUserClients(String userId) {
    try {
      return _firestore
          .collection('clients')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ClientModel.fromFirestore(doc.data(), doc.id))
                .toList();
          })
          .handleError((error) {
            print('Error reading all user clients: $error');
            return <ClientModel>[];
          });
    } catch (e) {
      print('Exception in getAllUserClients: $e');
      return Stream.value([]);
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get count of documents in a collection with optional filter
  Future<int> getCollectionCount(String collectionName,
      {String? fieldName, dynamic fieldValue}) async {
    try {
      Query query = _firestore.collection(collectionName);

      if (fieldName != null && fieldValue != null) {
        query = query.where(fieldName, isEqualTo: fieldValue);
      }

      final snapshot = await query.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting collection count: $e');
      return 0;
    }
  }

  /// Check if a document exists
  Future<bool> documentExists(String collectionName, String docId) async {
    try {
      final doc =
          await _firestore.collection(collectionName).doc(docId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }

  /// Get all documents from a collection (use with caution for large collections)
  Future<List<Map<String, dynamic>>> getAllDocuments(
      String collectionName) async {
    try {
      final snapshot = await _firestore.collection(collectionName).get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      print('Error reading all documents: $e');
      return [];
    }
  }
}
