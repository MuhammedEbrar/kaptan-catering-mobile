import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthDataSource {
  final ApiClient _apiClient;

  AuthDataSource(this._apiClient);

  // Login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Signup (Firma Kaydı)
  Future<AuthResponseModel> signup({
    required String email,
    required String password,
    required String name,
    required String companyName,
    required String taxNumber,
    required String taxOffice,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.signup,
        data: {
          'email': email,
          'password': password,
          'name': name,
          'companyName': companyName,
          'taxNumber': taxNumber,
          'taxOffice': taxOffice,
          'phone': phone,
          'address': address,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get Current User
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiConstants.me);

      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error Handler
  String _handleError(DioException error) {
    if (error.response != null) {
      // Backend'den gelen hata mesajı
      final message = error.response?.data['message'] ?? 
                      error.response?.data['error'] ?? 
                      'Bir hata oluştu';
      return message;
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Bağlantı zaman aşımına uğradı';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'İnternet bağlantısı yok';
    } else {
      return 'Beklenmeyen bir hata oluştu';
    }
  }
}