import 'dart:convert';

class AddressModel {
  final String? id;
  final String userId;
  final String title;
  final String address;
  final String phone;
  final bool isDefault;
  final DateTime? createdAt;

  AddressModel({
    this.id,
    required this.userId,
    required this.title,
    required this.address,
    required this.phone,
    this.isDefault = false,
    this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString(),
      userId: json['userId']?.toString() ?? json['user_id']?.toString() ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      isDefault: json['isDefault'] ?? json['is_default'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'title': title,
      'address': address,
      'phone': phone,
      'isDefault': isDefault,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  String toJsonString() => json.encode(toJson());

  factory AddressModel.fromJsonString(String jsonString) {
    return AddressModel.fromJson(json.decode(jsonString));
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? address,
    String? phone,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}