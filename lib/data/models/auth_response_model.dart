import 'user_model.dart';

class AuthResponseModel {
  final bool success;
  final String token;
  final UserModel user;
  final String? message;

  AuthResponseModel({
    required this.success,
    required this.token,
    required this.user,
    this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'user': user.toJson(),
      'message': message,
    };
  }

  // Hesap onaylı mı?
  bool get isAccountApproved => user.isApproved;
}