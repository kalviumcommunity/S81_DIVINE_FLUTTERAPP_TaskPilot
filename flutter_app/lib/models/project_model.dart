///
/// Project Model - Represents a single project document from Firestore
///
class ProjectModel {
  final String id;
  final String userId;
  final String clientId;
  final String name;
  final String description;
  final double budget;
  final String status; // 'not_started', 'in_progress', 'completed', 'on_hold'
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int taskCount;
  final int completedCount;

  ProjectModel({
    required this.id,
    required this.userId,
    required this.clientId,
    required this.name,
    required this.description,
    required this.budget,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.taskCount,
    required this.completedCount,
  });

  /// Factory constructor to create ProjectModel from Firestore document
  factory ProjectModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ProjectModel(
      id: docId,
      userId: data['userId'] ?? '',
      clientId: data['clientId'] ?? '',
      name: data['name'] ?? 'Untitled Project',
      description: data['description'] ?? '',
      budget: (data['budget'] ?? 0).toDouble(),
      status: data['status'] ?? 'not_started',
      startDate: data['startDate'] != null
          ? DateTime.parse(data['startDate'])
          : DateTime.now(),
      endDate: data['endDate'] != null
          ? DateTime.parse(data['endDate'])
          : DateTime.now().add(const Duration(days: 30)),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
      taskCount: data['taskCount'] ?? 0,
      completedCount: data['completedCount'] ?? 0,
    );
  }

  /// Convert ProjectModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'clientId': clientId,
      'name': name,
      'description': description,
      'budget': budget,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'taskCount': taskCount,
      'completedCount': completedCount,
    };
  }

  /// Calculate progress percentage
  double get progressPercentage =>
      taskCount > 0 ? (completedCount / taskCount) * 100 : 0;

  /// Check if project is overdue
  bool get isOverdue =>
      status != 'completed' && DateTime.now().isAfter(endDate);

  /// Get days remaining
  int get daysRemaining =>
      endDate.difference(DateTime.now()).inDays;

  /// Copy with method
  ProjectModel copyWith({
    String? id,
    String? userId,
    String? clientId,
    String? name,
    String? description,
    double? budget,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? taskCount,
    int? completedCount,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      taskCount: taskCount ?? this.taskCount,
      completedCount: completedCount ?? this.completedCount,
    );
  }
}
