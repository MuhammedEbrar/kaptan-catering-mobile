import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/product_model.dart';
import 'dart:convert';

class FavoriteProvider extends ChangeNotifier {
  final List<ProductModel> _favorites = [];
  bool _isLoading = false;

  List<ProductModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  int get favoriteCount => _favorites.length;

  // Favori mi kontrol et (String id ile)
  bool isFavorite(dynamic productId) {
    return _favorites.any((product) => product.id.toString() == productId.toString());
  }

  // Favorileri yükle (SharedPreferences'dan)
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList('favorites') ?? [];
      
      _favorites.clear();
      for (var json in favoritesJson) {
        final productMap = jsonDecode(json) as Map<String, dynamic>;
        _favorites.add(ProductModel.fromJson(productMap));
      }
    } catch (e) {
      debugPrint('Favoriler yüklenirken hata: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Favorilere ekle
  Future<void> addToFavorites(ProductModel product) async {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      await _saveFavorites();
      notifyListeners();
    }
  }

  // Favorilerden çıkar (dynamic productId)
  Future<void> removeFromFavorites(dynamic productId) async {
    _favorites.removeWhere((product) => product.id.toString() == productId.toString());
    await _saveFavorites();
    notifyListeners();
  }

  // Toggle (ekle/çıkar)
  Future<void> toggleFavorite(ProductModel product) async {
    if (isFavorite(product.id)) {
      await removeFromFavorites(product.id);
    } else {
      await addToFavorites(product);
    }
  }

  // Favorileri kaydet (SharedPreferences'a)
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favorites.map((product) {
        // Manuel JSON oluştur
        return jsonEncode({
          'id': product.id,
          'stok_kodu': product.stokKodu,
          'stok_adi': product.stokAdi,
          'kategori': product.kategori,
          'birim': product.birim,
          'fiyat': product.fiyat,
          'min_siparis_miktari': product.minSiparisMiktari,
        });
      }).toList();
      
      await prefs.setStringList('favorites', favoritesJson);
    } catch (e) {
      debugPrint('Favoriler kaydedilirken hata: $e');
    }
  }

  // Tüm favorileri temizle
  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }
}