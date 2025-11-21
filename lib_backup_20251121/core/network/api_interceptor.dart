import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class ApiInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Token'ı storage'dan al
    final token = await _storage.read(key: ApiConstants.tokenKey);

    // Eğer token varsa header'a ekle
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    print('🔵 REQUEST: ${options.method} ${options.path}');
    print('📦 DATA: ${options.data}');

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    print('📦 DATA: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    print('❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.path}');
    print('📦 ERROR DATA: ${err.response?.data}');
    print('📦 ERROR MESSAGE: ${err.message}');

    // 401 Unauthorized - Token geçersiz
    if (err.response?.statusCode == 401) {
      print('🔴 Token geçersiz, kullanıcı çıkış yapmalı');
      // TODO: Kullanıcıyı login ekranına yönlendir
    }

    handler.next(err);
  }
}