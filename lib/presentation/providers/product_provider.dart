import 'package:flutter/material.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/models/product_model.dart';
import 'dart:async';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductProvider(this._productRepository) {
    _initConnectivityListener();
  }

  // States
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isOffline = false; // 🆕 Offline durumu
  String? _errorMessage;
  String? _selectedCategory;
  String _searchQuery = '';
  
  // Pagination
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;

  // Debounce timer for search
  Timer? _debounceTimer;
  
  // Connectivity listener
  StreamSubscription? _connectivitySubscription;

  // Getters
  List<ProductModel> get products => _filteredProducts.isEmpty && _searchQuery.isEmpty && _selectedCategory == null
      ? _products
      : _filteredProducts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isOffline => _isOffline; // 🆕
  String? get errorMessage => _errorMessage;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get hasMore => _hasMore;
  int get productCount => products.length;

  // 🆕 Connectivity listener
  void _initConnectivityListener() {
    // İlk durumu kontrol et
    _checkConnectivity();
    
    // Not: NetworkChecker'ın stream'ini dinleyebiliriz ama şimdilik manuel kontrol yeterli
  }

  // 🆕 Bağlantı durumunu kontrol et
  Future<void> _checkConnectivity() async {
    try {
      final cacheInfo = await _productRepository.getCacheInfo();
      final wasOffline = _isOffline;
      _isOffline = !(cacheInfo['isOnline'] as bool);
      
      // Offline'dan online'a geçtiyse otomatik yenile
      if (wasOffline && !_isOffline && _products.isNotEmpty) {
        print('🔄 Online\'a geçildi, ürünler yenileniyor...');
        await loadProducts(forceRefresh: true);
      }
    } catch (e) {
      print('❌ Connectivity check error: $e');
    }
  }

  // Ürünleri yükle
  Future<void> loadProducts({bool forceRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      // Bağlantı durumunu kontrol et
      await _checkConnectivity();

      final fetchedProducts = await _productRepository.fetchProducts(
        page: _currentPage,
        limit: _pageSize,
        forceRefresh: forceRefresh,
      );

      _products = fetchedProducts;
      _applyFilters();
      _hasMore = fetchedProducts.length >= _pageSize;

      print('✅ ${fetchedProducts.length} ürün yüklendi');
      
      // Başarılıysa offline durumunu kaldır
      _isOffline = false;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ loadProducts hatası: $e');
      
      // İnternet hatası mı kontrol et
      if (_errorMessage?.contains('İnternet') == true || 
          _errorMessage?.contains('bağlantı') == true) {
        _isOffline = true;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Daha fazla ürün yükle (Pagination)
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore || _isLoading || _isOffline) return;
    if (_selectedCategory != null || _searchQuery.isNotEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      
      final moreProducts = await _productRepository.fetchProducts(
        page: _currentPage,
        limit: _pageSize,
      );

      if (moreProducts.isEmpty || moreProducts.length < _pageSize) {
        _hasMore = false;
      }

      _products.addAll(moreProducts);
      _applyFilters();

      print('✅ ${moreProducts.length} ürün daha yüklendi (Sayfa $_currentPage)');
    } catch (e) {
      _errorMessage = e.toString();
      _currentPage--;
      print('❌ loadMoreProducts hatası: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Kategoriye göre filtrele
  Future<void> filterByCategory(String? category) async {
    if (_selectedCategory == category) return;

    _selectedCategory = category;
    _searchQuery = '';
    _currentPage = 1;
    _hasMore = true;

    if (category == null || category.isEmpty) {
      _applyFilters();
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final filteredProducts = await _productRepository.fetchProductsByCategory(category);
      _filteredProducts = filteredProducts;
      
      print('✅ ${filteredProducts.length} ürün filtrelendi (Kategori: $category)');
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ filterByCategory hatası: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Arama (Debounce ile)
  void searchProducts(String query) {
    _searchQuery = query;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    if (_searchQuery.isEmpty) {
      _selectedCategory = null;
      _applyFilters();
      notifyListeners();
      return;
    }

    // LOCAL ARAMA (Client-side filtering)
    _selectedCategory = null;
    
    final query = _searchQuery.toLowerCase().trim();
    
    _filteredProducts = _products.where((product) {
      final stokAdi = product.stokAdi.toLowerCase();
      final stokKodu = product.stokKodu.toLowerCase();
      final kategori = product.kategori.toLowerCase();
      
      return stokAdi.contains(query) || 
             stokKodu.contains(query) || 
             kategori.contains(query);
    }).toList();
    
    print('🔍 ${_filteredProducts.length} ürün bulundu (Arama: $_searchQuery)');
    notifyListeners();
  }

  // Filtreleri uygula (local filtreleme)
  void _applyFilters() {
    if (_selectedCategory == null && _searchQuery.isEmpty) {
      _filteredProducts = [];
      return;
    }

    _filteredProducts = _products.where((product) {
      bool matchesCategory = _selectedCategory == null || 
          product.kategori.toLowerCase().contains(_selectedCategory!.toLowerCase());
      
      bool matchesSearch = _searchQuery.isEmpty ||
          product.stokAdi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.stokKodu.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Kategorileri al (unique)
  List<String> getCategories() {
    final categories = _products.map((p) => p.kategori).toSet().toList();
    categories.sort();
    return categories;
  }

  // Tek ürün getir
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final localProduct = _products.firstWhere(
        (p) => p.id == productId,
        orElse: () => _filteredProducts.firstWhere(
          (p) => p.id == productId,
          orElse: () => throw Exception('Not found'),
        ),
      );
      return localProduct;
    } catch (e) {
      try {
        return await _productRepository.fetchProductById(productId);
      } catch (e) {
        print('❌ getProductById hatası: $e');
        return null;
      }
    }
  }

  // Cache temizle ve yeniden yükle
  Future<void> refreshProducts() async {
    await _productRepository.clearCache();
    await loadProducts(forceRefresh: true);
  }

  // 🆕 Cache bilgisini al
  Future<Map<String, dynamic>> getCacheInfo() async {
    return await _productRepository.getCacheInfo();
  }

  // 🆕 Manuel bağlantı kontrolü (Pull-to-refresh için)
  Future<void> checkConnectivityAndRefresh() async {
    await _checkConnectivity();
    if (!_isOffline) {
      await refreshProducts();
    }
    notifyListeners();
  }

  // Reset
  void reset() {
    _products = [];
    _filteredProducts = [];
    _isLoading = false;
    _isLoadingMore = false;
    _isOffline = false;
    _errorMessage = null;
    _selectedCategory = null;
    _searchQuery = '';
    _currentPage = 1;
    _hasMore = true;
    _debounceTimer?.cancel();
    notifyListeners();
  }

  // Kategorileri döndür (CategoryProvider için)
  List<String> getAllCategories() {
    final categories = _products.map((p) => p.kategori).toSet().toList();
    categories.sort();
    return categories;
  }

  // Kategori bazlı ürün sayısı
  Map<String, int> getCategoryProductCount() {
    final Map<String, int> count = {};
    for (var product in _products) {
      count[product.kategori] = (count[product.kategori] ?? 0) + 1;
    }
    return count;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}