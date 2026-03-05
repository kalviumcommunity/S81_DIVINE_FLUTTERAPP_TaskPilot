import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/task_model.dart';
import '../constants/retro_theme.dart';

///
/// TaskDetailScreen - Display a single task document from Firestore
///
/// Features:
/// - Single document read using FutureBuilder
/// - Full task details display
/// - Estimated vs actual hours comparison
/// - Subtasks list
/// - Tags display
/// - Professional detail layout
///
class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📌 Task Details'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<TaskModel?>(
        future: firestoreService.getTaskById(taskId),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(RetroColors.neonCyan),
              ),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: RetroColors.neonPink),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading task',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonPink,
                        ),
                  ),
                ],
              ),
            );
          }

          // Task not found
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.task_alt,
                      size: 48, color: RetroColors.neonCyan),
                  const SizedBox(height: 16),
                  Text(
                    'Task not found',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonCyan,
                        ),
                  ),
                ],
              ),
            );
          }

          final task = snapshot.data!;
          return _TaskDetailContent(task: task);
        },
      ),
    );
  }
}

/// Task detail content widget
class _TaskDetailContent extends StatelessWidget {
  final TaskModel task;

  const _TaskDetailContent({required this.task});

  Color _getStatusColor() {
    switch (task.status) {
      case 'pending':
        return Colors.grey[700]!;
      case 'in_progress':
        return Colors.blue[700]!;
      case 'completed':
        return Colors.green[700]!;
      case 'on_hold':
        return Colors.amber[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case 'urgent':
        return RetroColors.neonPink;
      case 'high':
        return Colors.red[700]!;
      case 'medium':
        return Colors.orange[700]!;
      case 'low':
        return Colors.green[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.isOverdue && task.status != 'completed';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status badges
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Status and Priority badges
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.status.replaceAll('_', ' ').toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getPriorityColor().withOpacity(0.2),
                  border: Border.all(color: _getPriorityColor()),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.priority.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getPriorityColor(),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Description
          if (task.description.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: RetroColors.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

          // Due date and time tracking
          Row(
            children: [
              Expanded(
                child: _DetailCard(
                  icon: Icons.calendar_today,
                  label: 'Due Date',
                  value:
                      '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                  color: isOverdue ? RetroColors.neonPink : RetroColors
                      .neonCyan,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailCard(
                  icon: Icons.schedule,
                  label: 'Days Until Due',
                  value: isOverdue
                      ? '${task.daysUntilDue} overdue'
                      : '${task.daysUntilDue} days',
                  color: isOverdue ? RetroColors.neonPink : RetroColors
                      .neonGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hours tracking
          Row(
            children: [
              Expanded(
                child: _DetailCard(
                  icon: Icons.timer,
                  label: 'Estimated Hours',
                  value: '${task.estimatedHours}h',
                  color: RetroColors.neonGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailCard(
                  icon: Icons.timer_off,
                  label: 'Actual Hours',
                  value: '${task.actualHours}h',
                  color: RetroColors.neonCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tags
          if (task.tags.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tags',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: RetroColors.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: task.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: RetroColors.neonPurple.withOpacity(0.2),
                        border: Border.all(
                            color: RetroColors.neonPurple, width: 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: RetroColors.neonPurple,
                                ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),

          // Subtasks
          if (task.subtasks.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subtasks',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: RetroColors.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...task.subtasks.map((subtask) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: RetroColors.neonGreen,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            subtask,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
              ],
            ),

          // Timestamps
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimestampRow(
                  label: 'Created',
                  date: task.createdAt,
                ),
                const SizedBox(height: 8),
                _TimestampRow(
                  label: 'Last Updated',
                  date: task.updatedAt,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail card widget
class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[400],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

/// Timestamp row widget
class _TimestampRow extends StatelessWidget {
  final String label;
  final DateTime date;

  const _TimestampRow({
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey[400],
              ),
        ),
        Text(
          '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: RetroColors.neonCyan,
              ),
        ),
      ],
    );
  }
}
