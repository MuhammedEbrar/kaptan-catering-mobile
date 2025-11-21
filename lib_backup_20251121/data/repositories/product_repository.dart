import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../datasources/product_datasource.dart';
import '../models/product_model.dart';
import '../../core/utils/network_checker.dart';

class ProductRepository {
  final ProductDataSource _productDataSource;
  final SharedPreferences _prefs;
  final NetworkChecker _networkChecker = NetworkChecker();

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
      // İnternet bağlantısı kontrolü
      final isConnected = await _networkChecker.isConnected();

      // Cache kontrolü (sadece ilk sayfada ve filtre yoksa)
      if (page == 1 && 
          category == null && 
          searchQuery == null && 
          !forceRefresh) {
        
        // Önce cache'den dene
        final cachedProducts = await _loadFromCache();
        
        if (cachedProducts != null && cachedProducts.isNotEmpty) {
          final isCacheValid = await _isCacheValid();
          
          if (isCacheValid) {
            print('📦 Ürünler cache\'den yüklendi (${cachedProducts.length} ürün)');
            
            // Arka planda yenileme yap (fire and forget)
            if (isConnected) {
              _refreshCacheInBackground();
            }
            
            return cachedProducts;
          } else if (!isConnected) {
            // Cache süresi dolmuş ama internet yok, yine de cache'den dön
            print('⚠️ Cache süresi dolmuş ama çevrimdışısınız, cache kullanılıyor');
            return cachedProducts;
          }
        } else if (!isConnected) {
          // Cache yok ve internet yok
          throw 'İnternet bağlantısı yok ve önbellek boş. Lütfen internet bağlantınızı kontrol edin.';
        }
      }

      // İnternet yoksa ve cache de yoksa hata ver
      if (!isConnected) {
        final cachedProducts = await _loadFromCache();
        if (cachedProducts != null && cachedProducts.isNotEmpty) {
          print('⚠️ Çevrimdışı mod: Cache\'den yükleniyor');
          return cachedProducts;
        }
        throw 'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.';
      }

      // API'den çek
      print('🌐 API\'den ürünler yükleniyor...');
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
      
      // Hata durumunda cache'den dene (son çare)
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
      // İnternet kontrolü
      final isConnected = await _networkChecker.isConnected();
      
      if (!isConnected) {
        // Offline ise cache'den ara
        final cachedProducts = await _loadFromCache();
        if (cachedProducts != null) {
          final product = cachedProducts.firstWhere(
            (p) => p.id == productId,
            orElse: () => throw 'Ürün çevrimdışı modda bulunamadı',
          );
          return product;
        }
        throw 'İnternet bağlantısı yok';
      }

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

  // Cache geçerli mi?
  Future<bool> _isCacheValid() async {
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

  // Arka planda cache yenileme (sessiz)
  Future<void> _refreshCacheInBackground() async {
    try {
      print('🔄 Arka planda cache yenileniyor...');
      final products = await _productDataSource.getProducts(
        page: 1,
        limit: 20,
      );
      await _saveToCache(products);
      print('✅ Cache sessizce yenilendi');
    } catch (e) {
      print('⚠️ Arka plan yenileme başarısız (normal): $e');
      // Sessizce başarısız ol, kullanıcıya hata gösterme
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

  // Cache durumu bilgisi
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final cacheTime = _prefs.getInt(_cacheTimeKey);
      final isValid = await _isCacheValid();
      final cachedProducts = await _loadFromCache();
      final isConnected = await _networkChecker.isConnected();
      final connectionType = await _networkChecker.getConnectionType();

      return {
        'hasCachedData': cachedProducts != null && cachedProducts.isNotEmpty,
        'cachedProductCount': cachedProducts?.length ?? 0,
        'isCacheValid': isValid,
        'cacheAge': cacheTime != null 
            ? DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(cacheTime)).inHours
            : null,
        'isOnline': isConnected,
        'connectionType': connectionType,
      };
    } catch (e) {
      return {
        'hasCachedData': false,
        'cachedProductCount': 0,
        'isCacheValid': false,
        'cacheAge': null,
        'isOnline': false,
        'connectionType': 'Bilinmiyor',
      };
    }
  }
}