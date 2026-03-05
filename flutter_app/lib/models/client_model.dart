///
/// Client Model - Represents a single client document from Firestore
///
class ClientModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String taxId;
  final bool isActive;
  final double totalSpent;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.taxId,
    required this.isActive,
    required this.totalSpent,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to create ClientModel from Firestore document
  factory ClientModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ClientModel(
      id: docId,
      userId: data['userId'] ?? '',
      name: data['name'] ?? 'Unnamed Client',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      zipCode: data['zipCode'] ?? '',
      country: data['country'] ?? '',
      taxId: data['taxId'] ?? '',
      isActive: data['isActive'] ?? true,
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert ClientModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'taxId': taxId,
      'isActive': isActive,
      'totalSpent': totalSpent,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Get full address
  String get fullAddress =>
      '$address, $city, $state $zipCode, $country'
          .replaceAll(', , ', ', ')
          .replaceAll(RegExp(', +'), ', ');

  /// Copy with method
  ClientModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? taxId,
    bool? isActive,
    double? totalSpent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      taxId: taxId ?? this.taxId,
      isActive: isActive ?? this.isActive,
      totalSpent: totalSpent ?? this.totalSpent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
