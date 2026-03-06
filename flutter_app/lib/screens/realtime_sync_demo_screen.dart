import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/task_model.dart';
import '../constants/retro_theme.dart';

///
/// RealtimeSyncDemoScreen - Demonstrates real-time synchronization with Firestore
///
/// Features:
/// - Real-time collection listener showing live task updates
/// - Individual document listener tracking single task changes
/// - Document change tracking (added/modified/removed)
/// - Connection state indicators
/// - Server vs cache detection
/// - Live update animation indicators
///
class RealtimeSyncDemoScreen extends StatefulWidget {
  final String userId;

  const RealtimeSyncDemoScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<RealtimeSyncDemoScreen> createState() =>
      _RealtimeSyncDemoScreenState();
}

class _RealtimeSyncDemoScreenState extends State<RealtimeSyncDemoScreen>
    with TickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  late TabController _tabController;
  String _selectedTaskId = '';
  final Map<String, DateTime> _lastUpdateTimes = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _recordUpdate(String key) {
    setState(() {
      _lastUpdateTimes[key] = DateTime.now();
    });

    // Clear the indicator after 1 second
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastUpdateTimes.remove(key);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔄 Real-Time Sync Demo'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Collection'),
            Tab(text: 'Document'),
            Tab(text: 'Changes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCollectionListenerTab(),
          _buildDocumentListenerTab(),
          _buildChangeTrackerTab(),
        ],
      ),
    );
  }

  /// Tab 1: Collection Listener - Shows all tasks with live updates
  Widget _buildCollectionListenerTab() {
    return StreamBuilder<List<TaskModel>>(
      stream: _firestoreService.getUserTasks(widget.userId),
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
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
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
                const Icon(Icons.inbox_outlined,
                    size: 64, color: RetroColors.neonCyan),
                const SizedBox(height: 16),
                const Text('No tasks yet'),
                const SizedBox(height: 8),
                Text(
                  'Try adding a task in Firestore Console\nto see real-time updates here!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }

        // Data available - show list
        final tasks = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📡 Collection Listener Explanation',
                    style: TextStyle(
                      color: RetroColors.neonCyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This tab listens to the entire tasks collection for user "${widget.userId}". '
                    'Whenever any task is added, modified, or deleted in Firestore, the list '
                    'updates instantly without requiring a manual refresh.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Tasks: ${tasks.length}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: RetroColors.neonGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...tasks.map((task) {
              final hasUpdate = _lastUpdateTimes.containsKey(task.id);
              return _buildTaskCard(task, showUpdate: hasUpdate);
            }),
          ],
        );
      },
    );
  }

  /// Tab 2: Document Listener - Watch a single task for changes
  Widget _buildDocumentListenerTab() {
    return Column(
      children: [
        // Task selector
        Container(
          color: Colors.grey[900],
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🎯 Document Listener Explanation',
                style: TextStyle(
                  color: RetroColors.neonCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A document listener watches a single task for changes. '
                'Select a task below to see its real-time updates.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _buildTaskSelector(),
            ],
          ),
        ),
        // Document content
        Expanded(
          child: _selectedTaskId.isEmpty
              ? const Center(
                  child: Text('Select a task to watch'),
                )
              : StreamBuilder<TaskModel?>(
                  stream:
                      _firestoreService.watchTask(_selectedTaskId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              RetroColors.neonCyan),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.data == null) {
                      return const Center(
                        child: Text('Task not found'),
                      );
                    }

                    final task = snapshot.data!;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: _buildTaskDetailCard(task),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Tab 3: Change Tracker - Track added/modified/deleted documents
  Widget _buildChangeTrackerTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService
          .watchTasksCollectionSnapshot(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(RetroColors.neonCyan),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No data'));
        }

        final querySnapshot = snapshot.data!;
        final isFromServer =
            !querySnapshot.metadata.isFromCache;
        final hasPendingWrites =
            querySnapshot.metadata.hasPendingWrites;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Change Tracker Explanation',
                      style: TextStyle(
                        color: RetroColors.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This tab tracks detailed changes to documents: '
                      'added, modified, or removed. It also shows metadata.',
                      style:
                          Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Data Source: ',
                          style:
                              Theme.of(context).textTheme.labelSmall,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isFromServer
                                ? Colors.green[700]
                                : Colors.orange[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isFromServer ? 'Server' : 'Cache',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Pending Writes: ',
                          style:
                              Theme.of(context).textTheme.labelSmall,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasPendingWrites
                                ? Colors.orange[700]
                                : Colors.green[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            hasPendingWrites ? 'Yes' : 'No',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Document Changes (${querySnapshot.docChanges.length})',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: RetroColors.neonCyan,
                ),
              ),
              const SizedBox(height: 12),
              if (querySnapshot.docChanges.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('No changes detected yet'),
                )
              else
                ...querySnapshot.docChanges.map((change) {
                  return _buildChangeCard(change);
                }),
            ],
          ),
        );
      },
    );
  }

  /// Build task selector dropdown
  Widget _buildTaskSelector() {
    return StreamBuilder<List<TaskModel>>(
      stream: _firestoreService.getUserTasks(widget.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No tasks available');
        }

        final tasks = snapshot.data!;
        if (_selectedTaskId.isEmpty && tasks.isNotEmpty) {
          _selectedTaskId = tasks.first.id;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[700]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            value: _selectedTaskId,
            isExpanded: true,
            underline: const SizedBox(),
            items: tasks.map((task) {
              return DropdownMenuItem(
                value: task.id,
                child: Text(task.title),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTaskId = value ?? '';
              });
            },
          ),
        );
      },
    );
  }

  /// Build task card in collection view
  Widget _buildTaskCard(TaskModel task, {bool showUpdate = false}) {
    final isOverdue =
        task.isOverdue && task.status != 'completed';

    return AnimatedOpacity(
      opacity: showUpdate ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Card(
          color: Colors.grey[900],
          elevation: showUpdate ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: showUpdate
                  ? RetroColors.neonGreen
                  : (isOverdue
                      ? RetroColors.neonPink
                      : Colors.grey[700]!),
              width: showUpdate ? 3 : (isOverdue ? 2 : 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showUpdate)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: RetroColors.neonGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '✓ Updated',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Status: ${task.status}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Spacer(),
                    Text(
                      'Due: ${task.dueDate.toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build task detail card for document listener
  Widget _buildTaskDetailCard(TaskModel task) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: RetroColors.neonCyan,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow[900],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '🔴 Live Watching This Document',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('ID', task.id),
            _buildDetailRow('Title', task.title),
            _buildDetailRow('Description', task.description),
            _buildDetailRow('Status', task.status),
            _buildDetailRow('Priority', task.priority),
            _buildDetailRow('Due Date',
                task.dueDate.toString().split(' ')[0]),
            _buildDetailRow('Project', task.projectId),
            _buildDetailRow(
                'Created', task.createdAt.split('T')[0]),
            _buildDetailRow('Updated', task.updatedAt.split('T')[0]),
          ],
        ),
      ),
    );
  }

  /// Build a detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: RetroColors.neonCyan,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  /// Build document change card
  Widget _buildChangeCard(DocumentChange change) {
    final changeType = change.type.name;
    final color = changeType == 'added'
        ? Colors.green[700]
        : (changeType == 'modified'
            ? Colors.blue[700]
            : Colors.red[700]);

    final icon = changeType == 'added'
        ? '➕'
        : (changeType == 'modified'
            ? '✏️'
            : '❌');

    final data = change.doc.data() as Map<String, dynamic>;
    final title = data['title'] ?? 'Untitled';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      changeType.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Title: $title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${change.doc.id}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
