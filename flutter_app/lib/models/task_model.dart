///
/// Task Model - Represents a single task document from Firestore
///
class TaskModel {
  final String id;
  final String userId;
  final String projectId;
  final String clientId;
  final String title;
  final String description;
  final String status; // 'pending', 'in_progress', 'completed', 'on_hold'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> subtasks;
  final List<String> attachments;
  final List<String> tags;
  final int estimatedHours;
  final int actualHours;

  TaskModel({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.clientId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.subtasks,
    required this.attachments,
    required this.tags,
    required this.estimatedHours,
    required this.actualHours,
  });

  /// Factory constructor to create TaskModel from Firestore document snapshot
  factory TaskModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return TaskModel(
      id: docId,
      userId: data['userId'] ?? '',
      projectId: data['projectId'] ?? '',
      clientId: data['clientId'] ?? '',
      title: data['title'] ?? 'Untitled Task',
      description: data['description'] ?? '',
      status: data['status'] ?? 'pending',
      priority: data['priority'] ?? 'medium',
      dueDate: data['dueDate'] != null
          ? DateTime.parse(data['dueDate'])
          : DateTime.now().add(const Duration(days: 7)),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
      subtasks: List<String>.from(data['subtasks'] ?? []),
      attachments: List<String>.from(data['attachments'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      estimatedHours: data['estimatedHours'] ?? 0,
      actualHours: data['actualHours'] ?? 0,
    );
  }

  /// Convert TaskModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'projectId': projectId,
      'clientId': clientId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'subtasks': subtasks,
      'attachments': attachments,
      'tags': tags,
      'estimatedHours': estimatedHours,
      'actualHours': actualHours,
    };
  }

  /// Check if task is overdue
  bool get isOverdue =>
      status != 'completed' && DateTime.now().isAfter(dueDate);

  /// Get days until due
  int get daysUntilDue =>
      dueDate.difference(DateTime.now()).inDays;

  /// Copy with method for creating modified instances
  TaskModel copyWith({
    String? id,
    String? userId,
    String? projectId,
    String? clientId,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? subtasks,
    List<String>? attachments,
    List<String>? tags,
    int? estimatedHours,
    int? actualHours,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subtasks: subtasks ?? this.subtasks,
      attachments: attachments ?? this.attachments,
      tags: tags ?? this.tags,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
    );
  }
}
