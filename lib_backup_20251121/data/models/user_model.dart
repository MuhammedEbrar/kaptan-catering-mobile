import 'dart:convert';

class UserModel {
  final int id;
  final String email;
  final String name;
  final String role;
  final String? companyName;
  final String? taxNumber;
  final String? taxOffice;
  final String? phone;
  final String? address;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.companyName,
    this.taxNumber,
    this.taxOffice,
    this.phone,
    this.address,
  });

  // JSON'dan UserModel oluştur
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'company_user',
      companyName: json['companyName'],
      taxNumber: json['taxNumber'],
      taxOffice: json['taxOffice'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  // UserModel'i JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'companyName': companyName,
      'taxNumber': taxNumber,
      'taxOffice': taxOffice,
      'phone': phone,
      'address': address,
    };
  }

  // String'e çevir (local storage için)
  String toJsonString() => json.encode(toJson());

  // String'den oluştur (local storage'dan okurken)
  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }

  // Admin mi kontrol et
  bool get isAdmin => role == 'admin';
  
  // Company user mı kontrol et
  bool get isCompanyUser => role == 'company_user';
}
