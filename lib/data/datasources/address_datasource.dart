import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/address_model.dart';

class AddressDataSource {
  final ApiClient _apiClient;

  AddressDataSource(this._apiClient);

  // Kullanıcının adreslerini getir
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _apiClient.get('/addresses');

      if (response.data is List) {
        final List<dynamic> addressesJson = response.data;
        return addressesJson
            .map((json) => AddressModel.fromJson(json))
            .toList();
      } else if (response.data is Map) {
        final data = response.data['data'] ?? 
                     response.data['addresses'] ?? 
                     [];
        if (data is List) {
          return data
              .map((json) => AddressModel.fromJson(json))
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Yeni adres ekle
  Future<AddressModel> createAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await _apiClient.post(
        '/addresses',
        data: addressData,
      );

      if (response.data is Map) {
        final addressJson = response.data['address'] ?? 
                           response.data['data'] ?? 
                           response.data;
        return AddressModel.fromJson(addressJson);
      }

      throw 'Adres oluşturulamadı';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Adres güncelle
  Future<AddressModel> updateAddress(String addressId, Map<String, dynamic> addressData) async {
    try {
      final response = await _apiClient.put(
        '/addresses/$addressId',
        data: addressData,
      );

      if (response.data is Map) {
        final addressJson = response.data['address'] ?? 
                           response.data['data'] ?? 
                           response.data;
        return AddressModel.fromJson(addressJson);
      }

      throw 'Adres güncellenemedi';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Adres sil
  Future<void> deleteAddress(String addressId) async {
    try {
      await _apiClient.delete('/addresses/$addressId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
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