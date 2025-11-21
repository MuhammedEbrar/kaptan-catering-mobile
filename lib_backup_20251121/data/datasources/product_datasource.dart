import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';

class ProductDataSource {
  final ApiClient _apiClient;

  ProductDataSource(this._apiClient);

  // Tüm ürünleri getir
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  }) async {
    try {
      // Query parameters hazırla
      final queryParams = <String, dynamic>{};
      
      if (page > 0) queryParams['page'] = page;
      if (limit > 0) queryParams['limit'] = limit;
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final response = await _apiClient.get(
        ApiConstants.products,
        queryParameters: queryParams,
      );

      // Response formatını kontrol et
      if (response.data is List) {
        // Direkt liste dönüyorsa
        final List<dynamic> productsJson = response.data;
        return productsJson
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else if (response.data is Map) {
        // Obje içinde data field'ı varsa
        final data = response.data['data'] ?? response.data['products'] ?? [];
        if (data is List) {
          return data
              .map((json) => ProductModel.fromJson(json))
              .toList();
        }
      }

      // Hiçbiri değilse boş liste dön
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Tek ürün getir (ID ile)
  Future<ProductModel> getProductById(String productId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.products}/$productId',
      );

      if (response.data is Map) {
        // Direkt obje dönüyorsa
        if (response.data.containsKey('id')) {
          return ProductModel.fromJson(response.data);
        }
        // data field'ı içinde dönüyorsa
        if (response.data.containsKey('data')) {
          return ProductModel.fromJson(response.data['data']);
        }
      }

      throw 'Ürün bulunamadı';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Kategoriye göre ürünler
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    return getProducts(category: category);
  }

  // Arama
  Future<List<ProductModel>> searchProducts(String query) async {
    return getProducts(searchQuery: query);
  }

  // Error Handler
  String _handleError(DioException error) {
    if (error.response != null) {
      // Backend'den gelen hata mesajı
      final message = error.response?.data['message'] ??
          error.response?.data['error'] ??
          'Ürünler yüklenirken bir hata oluştu';
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