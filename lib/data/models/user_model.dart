import 'dart:convert';
import '../../core/constants/customer_type.dart';

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
  final bool isActive;
  final CustomerType? customerType;

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
    this.isActive = true,
    this.customerType,
  });

  // JSON'dan UserModel oluştur
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'company_user',
      companyName: json['companyName'] ?? json['company_name'],
      taxNumber: json['taxNumber'] ?? json['tax_number'],
      taxOffice: json['taxOffice'] ?? json['tax_office'],
      phone: json['phone'],
      address: json['address'],
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      customerType: json['customerType'] != null || json['customer_type'] != null
          ? CustomerType.fromString(json['customerType'] ?? json['customer_type'])
          : null,
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
      'isActive': isActive,
      'customerType': customerType?.value,
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

  // Onaylı hesap mı kontrol et
  bool get isApproved => isActive;

  // Müşteri tipi gösterim metni
  String get customerTypeDisplay => 
      customerType != null 
          ? '${customerType!.emoji} ${customerType!.displayName}'
          : '';
}