import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/order_model.dart';

class OrderDataSource {
  final ApiClient _apiClient;

  OrderDataSource(this._apiClient);

  // Sipariş oluştur
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.orders, // '/api/siparisler'
        data: orderData,
      );

      // Response'un formatını kontrol et
      if (response.data is Map) {
        // Direkt obje dönüyorsa
        if (response.data.containsKey('id') || response.data.containsKey('order')) {
          final orderJson = response.data['order'] ?? response.data;
          return OrderModel.fromJson(orderJson);
        }
        // data field'ı içinde dönüyorsa
        if (response.data.containsKey('data')) {
          return OrderModel.fromJson(response.data['data']);
        }
      }

      throw 'Sipariş oluşturulamadı';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Kullanıcının tüm siparişlerini getir
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _apiClient.get(ApiConstants.orders);

      // Response formatını kontrol et
      if (response.data is List) {
        // Direkt liste dönüyorsa
        final List<dynamic> ordersJson = response.data;
        return ordersJson
            .map((json) => OrderModel.fromJson(json))
            .toList();
      } else if (response.data is Map) {
        // Obje içinde data/orders field'ı varsa
        final data = response.data['data'] ?? 
                     response.data['orders'] ?? 
                     [];
        if (data is List) {
          return data
              .map((json) => OrderModel.fromJson(json))
              .toList();
        }
      }

      // Hiçbiri değilse boş liste dön
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Tek sipariş getir (ID ile)
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.orders}/$orderId',
      );

      if (response.data is Map) {
        // Direkt obje dönüyorsa
        if (response.data.containsKey('id')) {
          return OrderModel.fromJson(response.data);
        }
        // data field'ı içinde dönüyorsa
        if (response.data.containsKey('data')) {
          return OrderModel.fromJson(response.data['data']);
        }
      }

      throw 'Sipariş bulunamadı';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Sipariş durumuna göre filtrele
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.orders,
        queryParameters: {'status': status},
      );

      if (response.data is List) {
        final List<dynamic> ordersJson = response.data;
        return ordersJson
            .map((json) => OrderModel.fromJson(json))
            .toList();
      } else if (response.data is Map) {
        final data = response.data['data'] ?? 
                     response.data['orders'] ?? 
                     [];
        if (data is List) {
          return data
              .map((json) => OrderModel.fromJson(json))
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Sipariş iptal et
  Future<void> cancelOrder(String orderId) async {
    try {
      await _apiClient.patch(
        '${ApiConstants.orders}/$orderId',
        data: {'status': 'cancelled'},
      );
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
          'Sipariş işlemi sırasında bir hata oluştu';
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