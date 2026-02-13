import 'package:equatable/equatable.dart';

/// User Model for TaskPilot
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profilePic;
  final double hourlyRate;
  final String? phone;
  final String? company;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profilePic,
    this.hourlyRate = 0.0,
    this.phone,
    this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'hourlyRate': hourlyRate,
      'phone': phone,
      'company': company,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profilePic: json['profilePic'],
      hourlyRate: (json['hourlyRate'] ?? 0.0).toDouble(),
      phone: json['phone'],
      company: json['company'],
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: json['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  /// Copy with modifications
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePic,
    double? hourlyRate,
    String? phone,
    String? company,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        profilePic,
        hourlyRate,
        phone,
        company,
        createdAt,
        updatedAt,
      ];
}
