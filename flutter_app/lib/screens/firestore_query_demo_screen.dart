import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/task_model.dart';
import '../constants/retro_theme.dart';

///
/// FirestoreQueryDemoScreen - Interactive demonstrations of Firestore queries
///
/// Features:
/// - Filter queries (by status, priority, date range)
/// - Ordering/Sorting (ascending, descending)
/// - Limiting results
/// - Complex multi-condition queries
/// - Real-time filtered streams
/// - Search/pagination patterns
/// 
///
class FirestoreQueryDemoScreen extends StatefulWidget {
  final String userId;

  const FirestoreQueryDemoScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<FirestoreQueryDemoScreen> createState() =>
      _FirestoreQueryDemoScreenState();
}

class _FirestoreQueryDemoScreenState extends State<FirestoreQueryDemoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();

  // Filter state for advanced query
  String _selectedStatus = '';
  String _selectedPriority = '';
  int _limitCount = 25;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Firestore Queries Demo'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Filter'),
            Tab(text: 'Sorting'),
            Tab(text: 'Complex'),
            Tab(text: 'Recent'),
            Tab(text: 'Complete'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFilterQueriesTab(),
          _buildSortingQueriesTab(),
          _buildComplexQueriesTab(),
          _buildRecentUpdatesTab(),
          _buildCompletedTasksTab(),
        ],
      ),
    );
  }

  /// Tab 1: Filter Queries
  Widget _buildFilterQueriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationCard(
            'Filtering with where() allows you to retrieve only documents matching specific conditions.',
            Colors.blue[900]!,
          ),
          const SizedBox(height: 16),
          // Filter by status
          _buildQuerySection('Filter by Status',
              'Show tasks with specific status', _buildFilterByStatusDemo()),
          const SizedBox(height: 16),
          // Filter by priority
          _buildQuerySection('Filter by Priority',
              'Show high/urgent priority tasks', _buildFilterByPriorityDemo()),
          const SizedBox(height: 16),
          // Combined filters
          _buildQuerySection(
              'Multiple Filters',
              'Combine status and priority filters',
              _buildMultipleFiltersDemo()),
        ],
      ),
    );
  }

  /// Tab 2: Sorting/Ordering Queries
  Widget _buildSortingQueriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationCard(
            'Use orderBy() to sort results in ascending or descending order. You can chain multiple orderBy() calls.',
            Colors.green[900]!,
          ),
          const SizedBox(height: 16),
          _buildQuerySection(
            'Ascending Order (by Due Date)',
            'Tasks ordered earliest to latest',
            _buildOrderByDueDateDemo(),
          ),
          const SizedBox(height: 16),
          _buildQuerySection(
            'Descending Order (Recent Updates)',
            'Recently modified tasks first',
            _buildOrderByRecentDemo(),
          ),
          const SizedBox(height: 16),
          _buildQuerySection(
            'Multiple Sort Criteria',
            'Sort by priority then due date',
            _buildOrderByMultipleDemo(),
          ),
        ],
      ),
    );
  }

  /// Tab 3: Complex Queries
  Widget _buildComplexQueriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationCard(
            'Combine where(), orderBy(), and limit() for powerful filtered and sorted queries.',
            Colors.purple[900]!,
          ),
          const SizedBox(height: 16),
          _buildAdvancedQueryBuilder(),
        ],
      ),
    );
  }

  /// Tab 4: Recently Updated
  Widget _buildRecentUpdatesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationCard(
            'Get recently updated tasks ordered by updatedAt timestamp in descending order.',
            Colors.orange[900]!,
          ),
          const SizedBox(height: 16),
          _buildQuerySection(
            'Recent Tasks',
            'Ordered by most recent update',
            _buildRecentTasksDemo(),
          ),
        ],
      ),
    );
  }

  /// Tab 5: Completed Tasks
  Widget _buildCompletedTasksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationCard(
            'Query only completed tasks, ordered by completion date (status=\'completed\').',
            Colors.teal[900]!,
          ),
          const SizedBox(height: 16),
          _buildQuerySection(
            'Completed Tasks',
            'Tasks with status=\'completed\'',
            _buildCompletedTasksDemo(),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Individual Query Builders
  // ============================================================================

  Widget _buildFilterByStatusDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SelectableText(
            r'.where("status", isEqualTo: "pending")'
            '\n.orderBy("dueDate")',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<TaskModel>>(
          future: _firestoreService.queryTasksByStatusFuture(
              widget.userId, 'pending'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No pending tasks',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  Widget _buildFilterByPriorityDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SelectableText(
            r'.where("priority", whereIn: ["urgent", "high"])'
            '\n.orderBy("priority", descending: true)',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<TaskModel>>(
          future: _firestoreService.queryHighPriorityTasks(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No high priority tasks',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  Widget _buildMultipleFiltersDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SelectableText(
            r'.where("status", isEqualTo: "in_progress")'
            r'.where("priority", isEqualTo: "high")'
            '\n.orderBy("dueDate")',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<TaskModel>>(
          future: _firestoreService.queryTasksAdvanced(
            widget.userId,
            status: 'in_progress',
            priority: 'high',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No matching tasks',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  Widget _buildOrderByDueDateDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SelectableText(
            r'.orderBy("dueDate", descending: false)',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<TaskModel>>(
          stream: _firestoreService.getUserTasks(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No tasks',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  Widget _buildOrderByRecentDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SelectableText(
            r'.orderBy("updatedAt", descending: true)'
            '\n.limit(10)',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<TaskModel>>(
          future: _firestoreService.getRecentlyUpdatedTasks(widget.userId,
              limit: 10),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No updated tasks',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  Widget _buildOrderByMultipleDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SelectableText(
            r'.orderBy("priority", descending: true)'
            r'.orderBy("dueDate", descending: false)',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<TaskModel>>(
          stream: _firestoreService.streamIncompleteTasks(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No incomplete tasks',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  Widget _buildRecentTasksDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SelectableText(
            r'.orderBy("updatedAt", descending: true)'
            '\n.limit(20)',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<TaskModel>>(
          future: _firestoreService.getRecentlyUpdatedTasks(widget.userId,
              limit: 20),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No recent tasks',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  Widget _buildCompletedTasksDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SelectableText(
            r'.where("status", isEqualTo: "completed")'
            r'.orderBy("updatedAt", descending: true)'
            '\n.limit(50)',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<TaskModel>>(
          future: _firestoreService.getCompletedTasks(widget.userId, limit: 50),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No completed tasks',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedQueryBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Build Your Own Query',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Status filter
        _buildFilterButton(
          'Status',
          _selectedStatus.isEmpty ? 'All' : _selectedStatus,
          ['pending', 'in_progress', 'completed', 'on_hold'],
          (value) {
            setState(() => _selectedStatus = value);
          },
        ),
        const SizedBox(height: 8),
        // Priority filter
        _buildFilterButton(
          'Priority',
          _selectedPriority.isEmpty ? 'All' : _selectedPriority,
          ['urgent', 'high', 'medium', 'low'],
          (value) {
            setState(() => _selectedPriority = value);
          },
        ),
        const SizedBox(height: 8),
        // Limit slider
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[700]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Limit Results: $_limitCount',
                  style: Theme.of(context).textTheme.labelSmall),
              Slider(
                value: _limitCount.toDouble(),
                min: 5,
                max: 100,
                divisions: 19,
                label: _limitCount.toString(),
                onChanged: (value) {
                  setState(() => _limitCount = value.toInt());
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Code preview
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: SelectableText(
            _buildQueryCodePreview(),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        const SizedBox(height: 16),
        // Results
        StreamBuilder<List<TaskModel>>(
          stream: _firestoreService.streamFilteredTasks(
            widget.userId,
            status: _selectedStatus.isEmpty ? null : _selectedStatus,
            priority: _selectedPriority.isEmpty ? null : _selectedPriority,
            limitCount: _limitCount,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No results for this query',
                    style: Theme.of(context).textTheme.bodySmall),
              );
            }

            return _buildTaskList(snapshot.data!);
          },
        ),
      ],
    );
  }

  // ============================================================================
  // Helper Widgets
  // ============================================================================

  Widget _buildExplanationCard(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildQuerySection(String title, String subtitle, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: RetroColors.neonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildFilterButton(
    String label,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          DropdownButton<String>(
            value: currentValue,
            underline: SizedBox(),
            items: ['All', ...options]
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) =>
                onChanged(value ?? 'All' == "All" ? '' : value!),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> tasks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskTile(task);
      },
    );
  }

  Widget _buildTaskTile(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(task.status),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            task.status,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Due: ${task.dueDate.toString().split(' ')[0]}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
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

  Color _getStatusColor(String status) {
    switch (status) {
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

  String _buildQueryCodePreview() {
    String code = '.where("userId", isEqualTo: "$userId")';

    if (_selectedStatus.isNotEmpty) {
      code += '\n.where("status", isEqualTo: "$_selectedStatus")';
    }

    if (_selectedPriority.isNotEmpty) {
      code += '\n.where("priority", isEqualTo: "$_selectedPriority")';
    }

    code += '\n.orderBy("dueDate")';
    code += '\n.limit($_limitCount)';

    return code;
  }
}
