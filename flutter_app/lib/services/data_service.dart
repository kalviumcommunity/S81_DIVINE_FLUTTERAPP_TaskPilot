import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';

class DataService {
  static const String _tasksKey = 'tasks';
  static const String _clientsKey = 'clients';
  static const String _paymentsKey = 'payments';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Task Methods
  Future<List<Task>> getTasks() async {
    final tasksJson = _prefs.getStringList(_tasksKey) ?? [];
    return tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
  }

  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await _saveTasks(tasks);
  }

  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await _saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await _saveTasks(tasks);
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    await _prefs.setStringList(
      _tasksKey,
      tasks.map((t) => jsonEncode(t.toJson())).toList(),
    );
  }

  // Client Methods
  Future<List<Client>> getClients() async {
    final clientsJson = _prefs.getStringList(_clientsKey) ?? [];
    return clientsJson.map((json) => Client.fromJson(jsonDecode(json))).toList();
  }

  Future<void> addClient(Client client) async {
    final clients = await getClients();
    clients.add(client);
    await _saveClients(clients);
  }

  Future<void> _saveClients(List<Client> clients) async {
    await _prefs.setStringList(
      _clientsKey,
      clients.map((c) => jsonEncode(c.toJson())).toList(),
    );
  }

  // Payment Methods
  Future<List<Payment>> getPayments() async {
    final paymentsJson = _prefs.getStringList(_paymentsKey) ?? [];
    return paymentsJson.map((json) => Payment.fromJson(jsonDecode(json))).toList();
  }

  Future<void> addPayment(Payment payment) async {
    final payments = await getPayments();
    payments.add(payment);
    await _savePayments(payments);
  }

  Future<void> _savePayments(List<Payment> payments) async {
    await _prefs.setStringList(
      _paymentsKey,
      payments.map((p) => jsonEncode(p.toJson())).toList(),
    );
  }

  // Dashboard Statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    final tasks = await getTasks();
    final payments = await getPayments();

    double totalEarnings = 0;
    double paidAmount = 0;
    int completedTasks = 0;
    int pendingTasks = 0;
    int overdueTasks = 0;

    for (var task in tasks) {
      totalEarnings += task.amount;
      paidAmount += task.paidAmount;
      if (task.status == 'completed') completedTasks++;
      if (task.status == 'pending') pendingTasks++;
      if (task.isOverdue) overdueTasks++;
    }

    return {
      'totalEarnings': totalEarnings,
      'paidAmount': paidAmount,
      'pendingAmount': totalEarnings - paidAmount,
      'totalTasks': tasks.length,
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
      'overdueTasks': overdueTasks,
      'totalPayments': payments.length,
    };
  }
}
