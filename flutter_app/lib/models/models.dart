class Task {
  final String id;
  final String title;
  final String description;
  final String clientId;
  final String clientName;
  final double amount;
  final double paidAmount;
  final DateTime deadline;
  final DateTime createdAt;
  final double progress; // 0.0 to 1.0
  final String status; // 'pending', 'in_progress', 'completed', 'overdue'

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.clientId,
    required this.clientName,
    required this.amount,
    required this.paidAmount,
    required this.deadline,
    required this.createdAt,
    this.progress = 0.0,
    this.status = 'pending',
  });

  bool get isPaid => paidAmount >= amount;
  bool get isOverdue => DateTime.now().isAfter(deadline) && status != 'completed';
  double get remainingAmount => amount - paidAmount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'clientId': clientId,
        'clientName': clientName,
        'amount': amount,
        'paidAmount': paidAmount,
        'deadline': deadline.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'progress': progress,
        'status': status,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        clientId: json['clientId'],
        clientName: json['clientName'],
        amount: (json['amount'] as num).toDouble(),
        paidAmount: (json['paidAmount'] as num).toDouble(),
        deadline: DateTime.parse(json['deadline']),
        createdAt: DateTime.parse(json['createdAt']),
        progress: (json['progress'] as num).toDouble(),
        status: json['status'],
      );
}

class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

class Payment {
  final String id;
  final String taskId;
  final String clientName;
  final double amount;
  final DateTime date;
  final String method; // 'cash', 'bank_transfer', 'card', 'upi'
  final String status; // 'completed', 'pending', 'failed'

  Payment({
    required this.id,
    required this.taskId,
    required this.clientName,
    required this.amount,
    required this.date,
    required this.method,
    this.status = 'completed',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskId': taskId,
        'clientName': clientName,
        'amount': amount,
        'date': date.toIso8601String(),
        'method': method,
        'status': status,
      };

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        taskId: json['taskId'],
        clientName: json['clientName'],
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date']),
        method: json['method'],
        status: json['status'],
      );
}
