import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/project_model.dart';
import '../constants/retro_theme.dart';

///
/// ProjectsListScreen - Display all projects from Firestore in real-time
///
/// Features:
/// - Real-time updates using StreamBuilder
/// - Progress indicators
/// - Status badges
/// - Overdue project highlighting
/// - Budget display
/// - Auto-refresh on data changes
///
class ProjectsListScreen extends StatefulWidget {
  final String userId;

  const ProjectsListScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedStatus; // null = all, or specific status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 My Projects'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: DropdownButton<String?>(
                value: _selectedStatus,
                dropdownColor: Colors.grey[900],
                underline: Container(
                  height: 2,
                  color: Colors.grey[700]!,
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text(
                      'All Projects',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'not_started',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Not Started',
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
      body: StreamBuilder<List<ProjectModel>>(
        stream: _selectedStatus != null
            ? _firestoreService.getProjectsByStatus(
                widget.userId, _selectedStatus!)
            : _firestoreService.getUserProjects(widget.userId),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(RetroColors.neonGreen),
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
                    'Error loading projects',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonPink,
                        ),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_open,
                      size: 64, color: RetroColors.neonGreen),
                  const SizedBox(height: 16),
                  Text(
                    _selectedStatus != null
                        ? 'No $_selectedStatus projects yet'
                        : 'No projects yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: RetroColors.neonGreen,
                        ),
                  ),
                ],
              ),
            );
          }

          // Projects list
          final projects = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return _ProjectCard(project: project);
            },
          );
        },
      ),
    );
  }
}

/// Project card widget
class _ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _ProjectCard({required this.project});

  Color _getStatusColor() {
    switch (project.status) {
      case 'not_started':
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

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        project.isOverdue && project.status != 'completed';
    final progress = project.progressPercentage;

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
              // Project name and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
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
                      project.status
                          .replaceAll('_', ' ')
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              if (project.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${progress.toStringAsFixed(0)}% (${project.completedCount}/${project.taskCount})',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: RetroColors.neonCyan,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation(
                            RetroColors.neonCyan),
                      ),
                    ),
                  ],
                ),
              ),

              // Budget and deadline
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: RetroColors.neonGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '\$${project.budget.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: RetroColors.neonGreen,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isOverdue ? RetroColors.neonPink : RetroColors
                        .neonCyan,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isOverdue
                        ? '${project.daysRemaining} days overdue'
                        : '${project.daysRemaining} days left',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isOverdue
                              ? RetroColors.neonPink
                              : Colors.white,
                          fontWeight: isOverdue
                              ? FontWeight.bold
                              : FontWeight.normal,
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
