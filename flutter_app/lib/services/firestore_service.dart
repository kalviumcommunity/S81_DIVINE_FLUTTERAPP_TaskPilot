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

  // ============================================================================
  // TASKS COLLECTION WRITES
  // ============================================================================

  /// Create a new task with auto-generated ID
  Future<String?> createTask(TaskModel task) async {
    try {
      final docRef =
          await _firestore.collection('tasks').add(task.toMap());
      print('Task created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating task: $e');
      return null;
    }
  }

  /// Update specific task fields
  Future<bool> updateTask(String taskId, Map<String, dynamic> updates) async {
    try {
      // Add updatedAt timestamp
      updates['updatedAt'] =
          DateTime.now().toIso8601String();

      await _firestore.collection('tasks').doc(taskId).update(updates);
      print('Task $taskId updated successfully');
      return true;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  /// Update task status (common operation)
  Future<bool> updateTaskStatus(String taskId, String newStatus) async {
    return updateTask(taskId, {'status': newStatus});
  }

  /// Toggle task completion status
  Future<bool> toggleTaskCompletion(
      String taskId, bool currentStatus) async {
    return updateTask(
      taskId,
      {'status': currentStatus ? 'pending' : 'completed'},
    );
  }

  /// Delete a task (soft delete - mark as deleted)
  Future<bool> deleteTask(String taskId) async {
    try {
      await _firestore
          .collection('tasks')
          .doc(taskId)
          .update({'isDeleted': true, 'deletedAt': DateTime.now()
          .toIso8601String()});
      print('Task $taskId deleted (soft delete)');
      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  // ============================================================================
  // PROJECTS COLLECTION WRITES
  // ============================================================================

  /// Create a new project
  Future<String?> createProject(ProjectModel project) async {
    try {
      final docRef =
          await _firestore.collection('projects').add(project.toMap());
      print('Project created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating project: $e');
      return null;
    }
  }

  /// Update project fields
  Future<bool> updateProject(
      String projectId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] =
          DateTime.now().toIso8601String();

      await _firestore
          .collection('projects')
          .doc(projectId)
          .update(updates);
      print('Project $projectId updated successfully');
      return true;
    } catch (e) {
      print('Error updating project: $e');
      return false;
    }
  }

  /// Update project status
  Future<bool> updateProjectStatus(String projectId, String newStatus) async {
    return updateProject(projectId, {'status': newStatus});
  }

  /// Update project progress
  Future<bool> updateProjectProgress(
      String projectId, int taskCount, int completedCount) async {
    return updateProject(projectId, {
      'taskCount': taskCount,
      'completedCount': completedCount,
    });
  }

  /// Delete a project (soft delete)
  Future<bool> deleteProject(String projectId) async {
    try {
      await _firestore
          .collection('projects')
          .doc(projectId)
          .update({'isDeleted': true, 'deletedAt': DateTime.now()
          .toIso8601String()});
      print('Project $projectId deleted (soft delete)');
      return true;
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }

  // ============================================================================
  // CLIENTS COLLECTION WRITES
  // ============================================================================

  /// Create a new client
  Future<String?> createClient(ClientModel client) async {
    try {
      final docRef =
          await _firestore.collection('clients').add(client.toMap());
      print('Client created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating client: $e');
      return null;
    }
  }

  /// Update client fields
  Future<bool> updateClient(
      String clientId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] =
          DateTime.now().toIso8601String();

      await _firestore
          .collection('clients')
          .doc(clientId)
          .update(updates);
      print('Client $clientId updated successfully');
      return true;
    } catch (e) {
      print('Error updating client: $e');
      return false;
    }
  }

  /// Toggle client active/inactive status
  Future<bool> toggleClientStatus(String clientId, bool currentStatus) async {
    return updateClient(clientId, {'isActive': !currentStatus});
  }

  /// Update client total spent
  Future<bool> updateClientTotalSpent(
      String clientId, double newTotal) async {
    return updateClient(clientId, {'totalSpent': newTotal});
  }

  /// Deactivate a client (soft delete)
  Future<bool> deactivateClient(String clientId) async {
    try {
      await _firestore
          .collection('clients')
          .doc(clientId)
          .update({'isActive': false});
      print('Client $clientId deactivated');
      return true;
    } catch (e) {
      print('Error deactivating client: $e');
      return false;
    }
  }

  // ============================================================================
  // BATCH OPERATIONS
  // ============================================================================

  /// Batch update multiple documents
  Future<bool> batchUpdateTasks(
      List<String> taskIds, Map<String, dynamic> updates) async {
    try {
      final batch = _firestore.batch();
      updates['updatedAt'] =
          DateTime.now().toIso8601String();

      for (String taskId in taskIds) {
        batch.update(_firestore.collection('tasks').doc(taskId), updates);
      }

      await batch.commit();
      print('Batch updated ${taskIds.length} tasks');
      return true;
    } catch (e) {
      print('Error batch updating tasks: $e');
      return false;
    }
  }
}
