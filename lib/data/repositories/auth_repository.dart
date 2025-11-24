import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/customer_type.dart';
import '../datasources/auth_datasource.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../../core/constants/api_constants.dart';

class AuthRepository {
  final AuthDataSource _authDataSource;
  final FlutterSecureStorage _storage;

  AuthRepository(this._authDataSource, this._storage);

  // Login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authDataSource.login(
        email: email,
        password: password,
      );

      await _storage.write(
        key: ApiConstants.tokenKey,
        value: response.token,
      );

      await _storage.write(
        key: ApiConstants.userKey,
        value: response.user.toJsonString(),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Signup
  Future<AuthResponseModel> signup({
    required String email,
    required String password,
    required String name,
    required String companyName,
    required String taxNumber,
    required String taxOffice,
    required String phone,
    required String address,
    required CustomerType customerType,
  }) async {
    try {
      final response = await _authDataSource.signup(
        email: email,
        password: password,
        name: name,
        companyName: companyName,
        taxNumber: taxNumber,
        taxOffice: taxOffice,
        phone: phone,
        address: address,
        customerType: customerType,
      );

      await _storage.write(
        key: ApiConstants.tokenKey,
        value: response.token,
      );

      await _storage.write(
        key: ApiConstants.userKey,
        value: response.user.toJsonString(),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get Current User
  Future<UserModel?> getCurrentUser() async {
    try {
      final userString = await _storage.read(key: ApiConstants.userKey);
      if (userString != null) {
        return UserModel.fromJsonString(userString);
      }

      final user = await _authDataSource.getCurrentUser();
      await _storage.write(
        key: ApiConstants.userKey,
        value: user.toJsonString(),
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: ApiConstants.tokenKey);
    return token != null;
  }

  Future<void> logout() async {
    await _storage.delete(key: ApiConstants.tokenKey);
    await _storage.delete(key: ApiConstants.userKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: ApiConstants.tokenKey);
  }
}