import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../datasources/product_datasource.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductDataSource _productDataSource;
  final SharedPreferences _prefs;

  ProductRepository(this._productDataSource, this._prefs);

  // Cache keys
  static const String _cacheKey = 'cached_products';
  static const String _cacheTimeKey = 'products_cache_time';
  static const int _cacheDurationHours = 24;

  // Tüm ürünleri getir
  Future<List<ProductModel>> fetchProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    try {
      // Cache kontrolü (sadece ilk sayfada ve filtre yoksa)
      if (page == 1 && 
          category == null && 
          searchQuery == null && 
          !forceRefresh) {
        final cachedProducts = await _loadFromCache();
        if (cachedProducts != null && cachedProducts.isNotEmpty) {
          print('📦 Ürünler cache\'den yüklendi (${cachedProducts.length} ürün)');
          return cachedProducts;
        }
      }

      // API'den çek
      final products = await _productDataSource.getProducts(
        page: page,
        limit: limit,
        category: category,
        searchQuery: searchQuery,
      );

      // İlk sayfayı cache'le (filtre yoksa)
      if (page == 1 && category == null && searchQuery == null) {
        await _saveToCache(products);
        print('💾 Ürünler cache\'e kaydedildi (${products.length} ürün)');
      }

      return products;
    } catch (e) {
      print('❌ fetchProducts hatası: $e');
      
      // Hata durumunda cache'den dene
      final cachedProducts = await _loadFromCache();
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        print('📦 Hata sonrası cache\'den yüklendi');
        return cachedProducts;
      }
      
      rethrow;
    }
  }

  // Tek ürün getir
  Future<ProductModel> fetchProductById(String productId) async {
    try {
      return await _productDataSource.getProductById(productId);
    } catch (e) {
      print('❌ fetchProductById hatası: $e');
      rethrow;
    }
  }

  // Kategoriye göre ürünler
  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    return fetchProducts(category: category);
  }

  // Arama
  Future<List<ProductModel>> searchProducts(String query) async {
    if (query.isEmpty) {
      return fetchProducts();
    }
    return fetchProducts(searchQuery: query);
  }

  // Cache'e kaydet
  Future<void> _saveToCache(List<ProductModel> products) async {
    try {
      final productsJson = products.map((p) => p.toJson()).toList();
      final jsonString = json.encode(productsJson);
      
      await _prefs.setString(_cacheKey, jsonString);
      await _prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('❌ Cache kaydetme hatası: $e');
    }
  }

  // Cache'den yükle
  Future<List<ProductModel>?> _loadFromCache() async {
    try {
      // Cache var mı?
      final jsonString = _prefs.getString(_cacheKey);
      if (jsonString == null) return null;

      // Cache süresi dolmuş mu?
      final cacheTime = _prefs.getInt(_cacheTimeKey);
      if (cacheTime == null) return null;

      final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
      final now = DateTime.now();
      final difference = now.difference(cacheDate);

      if (difference.inHours > _cacheDurationHours) {
        print('⏰ Cache süresi dolmuş (${difference.inHours} saat)');
        return null;
      }

      // Parse et
      final List<dynamic> productsJson = json.decode(jsonString);
      final products = productsJson
          .map((json) => ProductModel.fromJson(json))
          .toList();

      return products;
    } catch (e) {
      print('❌ Cache yükleme hatası: $e');
      return null;
    }
  }

  // Cache'i temizle
  Future<void> clearCache() async {
    try {
      await _prefs.remove(_cacheKey);
      await _prefs.remove(_cacheTimeKey);
      print('🗑️ Cache temizlendi');
    } catch (e) {
      print('❌ Cache temizleme hatası: $e');
    }
  }

  // Cache durumu
  Future<bool> isCacheValid() async {
    try {
      final cacheTime = _prefs.getInt(_cacheTimeKey);
      if (cacheTime == null) return false;

      final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
      final now = DateTime.now();
      final difference = now.difference(cacheDate);

      return difference.inHours <= _cacheDurationHours;
    } catch (e) {
      return false;
    }
  }
}