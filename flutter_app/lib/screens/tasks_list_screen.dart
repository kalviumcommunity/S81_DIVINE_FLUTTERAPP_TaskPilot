import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/task_model.dart';
import '../constants/retro_theme.dart';

///
/// TasksListScreen - Display all tasks from Firestore in real-time
///
/// Features:
/// - Real-time updates using StreamBuilder
/// - Status indicators (color-coded)
/// - Priority badges
/// - Overdue task highlighting
/// - Filter by status option
/// - Auto-refresh when Firestore data changes
///
class TasksListScreen extends StatefulWidget {
  final String userId;

  const TasksListScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedStatus; // null = all, 'pending' = pending only, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 My Tasks'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        actions: [
          // Status filter dropdown
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: DropdownButton<String?>(
                value: _selectedStatus,
                dropdownColor: Colors.grey[900],
                underline: Container(
                  height: 2,
                  color: RetroColors.neonCyan,
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text(
                      'All Tasks',
                      style: TextStyle(color: RetroColors.neonCyan),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'pending',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Pending',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'in_progress',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'In Progress',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'completed',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
        // If status filter selected, use filtered stream, otherwise get all
        stream: _selectedStatus != null
            ? _firestoreService.getTasksByStatus(
                widget.userId, _selectedStatus!)
            : _firestoreService.getUserTasks(widget.userId),
        builder: (context, snapshot) {
          // Show loading indicator while fetching
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(RetroColors.neonCyan),
              ),
            );
          }

          // Handle errors
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: RetroColors.neonPink),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading tasks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonPink,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          // Show empty state if no tasks
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined,
                      size: 64, color: RetroColors.neonCyan),
                  const SizedBox(height: 16),
                  Text(
                    _selectedStatus != null
                        ? 'No $_selectedStatus tasks yet'
                        : 'No tasks yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonCyan,
                        ),
                  ),
                ],
              ),
            );
          }

          // Display list of tasks
          final tasks = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _TaskCard(task: task);
            },
          );
        },
      ),
    );
  }
}

/// Task card widget for displaying individual task
class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

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
    final isOverdue =
        task.isOverdue && task.status != 'completed';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        color: Colors.grey[900],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isOverdue ? RetroColors.neonPink : Colors.grey[700]!,
            width: isOverdue ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task title and status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.status.replaceAll('_', ' ').toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              if (task.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Priority badge and due date
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  const Spacer(),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isOverdue ? RetroColors.neonPink : RetroColors
                        .neonCyan,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isOverdue
                        ? '${task.daysUntilDue} days overdue'
                        : 'Due in ${task.daysUntilDue} days',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              isOverdue ? RetroColors.neonPink : Colors.white,
                          fontWeight: isOverdue ? FontWeight.bold : FontWeight
                              .normal,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
