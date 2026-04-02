import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({Key? key}) : super(key: key);

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  late DataService dataService;
  int _currentIndex = 0;
  List<Task> tasks = [];
  List<Client> clients = [];
  List<Payment> payments = [];
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    dataService = DataService();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await dataService.init();
    await _loadData();
    _addSampleData();
  }

  Future<void> _loadData() async {
    final loadedTasks = await dataService.getTasks();
    final loadedClients = await dataService.getClients();
    final loadedPayments = await dataService.getPayments();
    final loadedStats = await dataService.getDashboardStats();

    setState(() {
      tasks = loadedTasks;
      clients = loadedClients;
      payments = loadedPayments;
      stats = loadedStats;
    });
  }

  Future<void> _addSampleData() async {
    final existingTasks = await dataService.getTasks();
    if (existingTasks.isEmpty) {
      final sampleClients = [
        Client(
          id: uuid.v4(),
          name: 'TechStartup Inc.',
          email: 'contact@techstartup.com',
          phone: '+1 (555) 123-4567',
          createdAt: DateTime.now(),
        ),
        Client(
          id: uuid.v4(),
          name: 'Design Studio Co.',
          email: 'info@designstudio.com',
          phone: '+1 (555) 987-6543',
          createdAt: DateTime.now(),
        ),
      ];

      for (var client in sampleClients) {
        await dataService.addClient(client);
      }

      final sampleTasks = [
        Task(
          id: uuid.v4(),
          title: 'NEON_GENESIS_BRANDING',
          description: 'Complete branding overhaul with logo redesign and brand guidelines',
          clientId: sampleClients[0].id,
          clientName: sampleClients[0].name,
          amount: 5000,
          paidAmount: 3000,
          deadline: DateTime.now().add(Duration(days: 10)),
          createdAt: DateTime.now(),
          progress: 0.75,
          status: 'in_progress',
        ),
        Task(
          id: uuid.v4(),
          title: 'INTERFACE_REDESIGN',
          description: 'Redesign user interface for mobile and web applications',
          clientId: sampleClients[0].id,
          clientName: sampleClients[0].name,
          amount: 3000,
          paidAmount: 0,
          deadline: DateTime.now().add(Duration(days: 5)),
          createdAt: DateTime.now(),
          progress: 0.4,
          status: 'in_progress',
        ),
        Task(
          id: uuid.v4(),
          title: 'DATABASE_SYNC_ERROR',
          description: 'Fix critical database synchronization issues in production',
          clientId: sampleClients[1].id,
          clientName: sampleClients[1].name,
          amount: 2000,
          paidAmount: 2000,
          deadline: DateTime.now().add(Duration(days: 2)),
          createdAt: DateTime.now(),
          progress: 0.75,
          status: 'pending',
        ),
        Task(
          id: uuid.v4(),
          title: 'ARCHIVE_CLEANUP',
          description: 'Organize and archive old project files and documentation',
          clientId: sampleClients[1].id,
          clientName: sampleClients[1].name,
          amount: 1500,
          paidAmount: 1500,
          deadline: DateTime.now().add(Duration(days: 20)),
          createdAt: DateTime.now(),
          progress: 1.0,
          status: 'completed',
        ),
      ];

      for (var task in sampleTasks) {
        await dataService.addTask(task);
      }

      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131022),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildTasksScreen();
      case 2:
        return _buildPaymentsScreen();
      case 3:
        return _buildClientsScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          backgroundColor: const Color(0xFF131022),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3713EC), Color(0xFF131022)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'THE_BRIDGE.v2',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unified Freelance Management',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(),
                const SizedBox(height: 24),
                _buildUpcomingDeadlines(),
                const SizedBox(height: 24),
                _buildRecentPayments(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard(
          'Total Earnings',
          '\$${stats['totalEarnings']?.toStringAsFixed(0) ?? '0'}',
          const Color(0xFF3713EC),
        ),
        _buildStatCard(
          'Paid Amount',
          '\$${stats['paidAmount']?.toStringAsFixed(0) ?? '0'}',
          const Color(0xFFFF6B00),
        ),
        _buildStatCard(
          'Pending Payment',
          '\$${stats['pendingAmount']?.toStringAsFixed(0) ?? '0'}',
          const Color(0xFFFF6B00),
        ),
        _buildStatCard(
          'Total Tasks',
          '${stats['totalTasks'] ?? 0}',
          const Color(0xFF3713EC),
        ),
        _buildStatCard(
          'Completed',
          '${stats['completedTasks'] ?? 0}',
          Colors.green,
        ),
        _buildStatCard(
          'Overdue',
          '${stats['overdueTasks'] ?? 0}',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1628),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDeadlines() {
    final upcoming = tasks
        .where((t) => t.status != 'completed')
        .toList()
        ..sort((a, b) => a.deadline.compareTo(b.deadline));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'UPCOMING DEADLINES',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const Divider(color: Colors.white10, height: 16),
        ...upcoming.take(3).map((task) {
          final daysLeft = task.deadline.difference(DateTime.now()).inDays;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTaskMini(task, daysLeft),
          );
        }),
      ],
    );
  }

  Widget _buildTaskMini(Task task, int daysLeft) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: daysLeft < 3
              ? Colors.red.withOpacity(0.5)
              : const Color(0xFF3713EC).withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF1a1628),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  task.clientName,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$daysLeft days',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: daysLeft < 3 ? Colors.red : const Color(0xFFFF6B00),
                  fontSize: 11,
                ),
              ),
              Text(
                '\$${task.remainingAmount.toStringAsFixed(0)} due',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF3713EC),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPayments() {
    final recent = payments.length > 3 ? payments.sublist(0, 3) : payments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECENT PAYMENTS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const Divider(color: Colors.white10, height: 16),
        ...recent.map((payment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFF3713EC).withOpacity(0.2)),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF1a1628),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.clientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          payment.method,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+\$${payment.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTasksScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('ACTIVE_MISSIONS.LOG'),
          backgroundColor: const Color(0xFF3713EC),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: tasks.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.only(top: 32.0),
                        child: Text(
                          'No tasks yet. Create one to get started!',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ]
                  : tasks
                      .map((task) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildTaskCard(task),
                          ))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task) {
    return GestureDetector(
      onTap: () => _showTaskDetails(task),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1628),
          border: Border.all(
            color: task.isPaid
                ? Colors.green.withOpacity(0.3)
                : const Color(0xFF3713EC).withOpacity(0.2),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.clientName,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _getStatusColor(task.status),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(task.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: task.progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(
                task.isPaid ? Colors.green : const Color(0xFFFF6B00),
              ),
              minHeight: 6,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount: \$${task.amount}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF3713EC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Paid: \$${task.paidAmount}',
                      style: TextStyle(
                        fontSize: 11,
                        color: task.isPaid ? Colors.green : Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Deadline: ${task.deadline.day}/${task.deadline.month}',
                      style: TextStyle(
                        fontSize: 10,
                        color: task.isOverdue
                            ? Colors.red
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                    if (task.isOverdue)
                      const Text(
                        'OVERDUE',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return const Color(0xFFFF6B00);
      case 'pending':
        return const Color(0xFF3713EC);
      case 'overdue':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Widget _buildPaymentsScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('PAYMENT_TRACKER'),
          backgroundColor: const Color(0xFFFF6B00),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1628),
                    border: Border.all(
                      color: const Color(0xFFFF6B00).withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Received',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '\$${payments.fold(0.0, (sum, p) => sum + p.amount).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.trending_up,
                        color: Colors.green,
                        size: 32,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PAYMENT_HISTORY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const Divider(color: Colors.white10, height: 16),
                ...payments.isEmpty
                    ? [
                        const Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: Text(
                            'No payments received yet',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ]
                    : payments.map((payment) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF3713EC).withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFF1a1628),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        payment.clientName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${payment.method} • ${payment.date.day}/${payment.date.month}/${payment.date.year}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '+\$${payment.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      payment.status,
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClientsScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('CLIENT_MANAGEMENT'),
          backgroundColor: const Color(0xFF3713EC),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildClientsList(),
          ),
        ),
      ],
    );
  }

  Widget _buildClientsList() {
    if (clients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: Text(
          'No clients yet. Add one to get started!',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      );
    }

    return Column(
      children: clients.map((client) {
        final clientTasks = tasks.where((t) => t.clientId == client.id).toList();
        final totalEarned = clientTasks.fold<double>(
          0,
          (sum, t) => sum + t.paidAmount,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1628),
              border: Border.all(
                color: const Color(0xFF3713EC).withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  client.email,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                Text(
                  client.phone,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${clientTasks.length} tasks',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF3713EC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Earned: \$${totalEarned.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131022).withOpacity(0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.dashboard_rounded, 'Deck', 0),
            _buildNavItem(Icons.assignment_rounded, 'Tasks', 1),
            const SizedBox(width: 60),
            _buildNavItem(Icons.payment_rounded, 'Payments', 2),
            _buildNavItem(Icons.people_rounded, 'Clients', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF3713EC) : Colors.white54,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF3713EC) : Colors.white54,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3713EC).withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        backgroundColor: const Color(0xFF3713EC),
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final clientNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1628),
        title: const Text('Create New Task', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  labelStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: clientNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Client Name',
                  labelStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (\$)',
                  labelStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  clientNameController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                final newTask = Task(
                  id: uuid.v4(),
                  title: titleController.text,
                  description: descriptionController.text,
                  clientId: uuid.v4(),
                  clientName: clientNameController.text,
                  amount: double.parse(amountController.text),
                  paidAmount: 0,
                  deadline: DateTime.now().add(const Duration(days: 7)),
                  createdAt: DateTime.now(),
                  progress: 0,
                  status: 'pending',
                );

                await dataService.addTask(newTask);
                await _loadData();
                Navigator.pop(context);
              }
            },
            child: const Text('Create', style: TextStyle(color: Color(0xFF3713EC))),
          ),
        ],
      ),
    );
  }

  // Generate realistic transaction ID
  String _generateTransactionId() {
    final timestamp = DateTime.now();
    final random = (timestamp.millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
    return 'PPAY_${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_$random';
  }

  void _showPaymentInterface(Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1628),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Complete Payment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pay ${task.clientName}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),

              // Amount Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF131022),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF3713EC).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount to Pay',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          '₹',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF3713EC),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.remainingAmount.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'For: ${task.title}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3713EC).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Invoice',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF3713EC),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Payment Methods
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              
              // PhonePe Option
              _buildPaymentMethodButton(
                onTap: () => _processPhonePePayment(context, task),
                icon: '📱',
                title: 'PhonePe',
                subtitle: 'UPI Payment',
                isHighlighted: true,
              ),
              const SizedBox(height: 10),
              
              // Google Pay Option
              _buildPaymentMethodButton(
                onTap: () => _processPaymentSimulation(context, task, 'Google Pay'),
                icon: '🔵',
                title: 'Google Pay',
                subtitle: 'UPI & Cards',
              ),
              const SizedBox(height: 10),
              
              // Bank Transfer Option
              _buildPaymentMethodButton(
                onTap: () => _processPaymentSimulation(context, task, 'Bank Transfer'),
                icon: '🏦',
                title: 'Bank Transfer',
                subtitle: 'Direct Account',
              ),
              const SizedBox(height: 28),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(
                      color: Colors.white24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton({
    required VoidCallback onTap,
    required String icon,
    required String title,
    required String subtitle,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isHighlighted 
            ? const Color(0xFF3713EC).withOpacity(0.1)
            : const Color(0xFF131022),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted
              ? const Color(0xFF3713EC).withOpacity(0.5)
              : Colors.white12,
          ),
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (isHighlighted)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF3713EC),
                size: 24,
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white24,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  void _processPhonePePayment(BuildContext context, Task task) {
    Navigator.pop(context);
    _showPhonePeInterface(context, task);
  }

  void _processPaymentSimulation(BuildContext context, Task task, String method) {
    Navigator.pop(context);
    _showPaymentProcessing(context, task, method);
  }

  void _showPhonePeInterface(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1628),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'PhonePe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // UPI ID Input
              const Text(
                'UPI ID',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'yourname@phonepe',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                  ),
                  prefixIcon: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white30,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF131022),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white12,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white12,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF3713EC),
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Amount Summary
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF131022),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '₹${task.remainingAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Pay Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3713EC),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showPaymentProcessing(context, task, 'PhonePe');
                  },
                  child: const Text(
                    'Proceed to Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentProcessing(BuildContext context, Task task, String method) {
    final navigator = Navigator.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1a1628),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF3713EC).withOpacity(0.3),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              
              // Animated processing indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3713EC).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Text(
                    '⏳',
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Processing Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'via $method',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation(
                      const Color(0xFF3713EC).withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate payment processing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        try {
          navigator.pop(); // Close processing dialog
          _showPaymentSuccess(context, task, method);
        } catch (e) {
          // Navigator might not be available in some contexts
        }
      }
    });
  }

  void _showPaymentSuccess(BuildContext context, Task task, String method) {
    final transactionId = _generateTransactionId();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1a1628),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Colors.green,
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Payment Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF131022),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Amount', '₹${task.remainingAmount.toStringAsFixed(0)}'),
                    const SizedBox(height: 10),
                    _buildDetailRow('Method', method),
                    const SizedBox(height: 10),
                    _buildDetailRow('Transaction ID', transactionId),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                      'Time',
                      '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    // Record payment in database
                    final payment = Payment(
                      id: transactionId,
                      taskId: task.id,
                      clientName: task.clientName,
                      amount: task.remainingAmount,
                      date: DateTime.now(),
                      method: method,
                    );
                    await dataService.addPayment(payment);

                    // Update task as completed
                    final updatedTask = Task(
                      id: task.id,
                      title: task.title,
                      description: task.description,
                      clientId: task.clientId,
                      clientName: task.clientName,
                      amount: task.amount,
                      paidAmount: task.amount,
                      deadline: task.deadline,
                      createdAt: task.createdAt,
                      progress: 1.0,
                      status: 'completed',
                    );
                    await dataService.updateTask(updatedTask);
                    await _loadData();
                    
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1628),
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          task.clientName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await dataService.deleteTask(task.id);
                      await _loadData();
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF131022),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Contract Amount:',
                            style: TextStyle(color: Colors.white70)),
                        Text('\$${task.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Color(0xFF3713EC),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount Paid:',
                            style: TextStyle(color: Colors.white70)),
                        Text('\$${task.paidAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Remaining:',
                            style: TextStyle(color: Colors.white70)),
                        Text('\$${task.remainingAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: task.remainingAmount > 0
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Deadline:',
                            style: TextStyle(color: Colors.white70)),
                        Text(
                            '${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                            style: TextStyle(
                                color: task.isOverdue ? Colors.red : Colors.white70,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Progress:', style: TextStyle(color: Colors.white70)),
                        Text('${(task.progress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                                color: Colors.white70, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3713EC),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    if (!task.isPaid) {
                      // Close current modal and show payment interface
                      Navigator.pop(context);
                      _showPaymentInterface(task);
                    }
                  },
                  child: Text(
                    task.isPaid ? 'PAID ✓' : 'PAY NOW',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
