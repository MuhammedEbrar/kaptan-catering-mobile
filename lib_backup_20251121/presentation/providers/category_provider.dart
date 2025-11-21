import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class CategoryProvider extends ChangeNotifier {
  // States
  List<String> _categories = [];
  String? _selectedCategory;
  Map<String, int> _categoryProductCount = {};

  // Getters
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  Map<String, int> get categoryProductCount => _categoryProductCount;
  bool get hasSelectedCategory => _selectedCategory != null;

  // Kategorileri ürün listesinden çıkar
  void extractCategories(List<ProductModel> products) {
    if (products.isEmpty) {
      _categories = [];
      _categoryProductCount = {};
      notifyListeners();
      return;
    }

    // Unique kategorileri bul
    final categorySet = products.map((p) => p.kategori).toSet();
    _categories = categorySet.toList();
    _categories.sort(); // Alfabetik sırala

    // Her kategoride kaç ürün var say
    _categoryProductCount = {};
    for (var category in _categories) {
      final count = products.where((p) => p.kategori == category).length;
      _categoryProductCount[category] = count;
    }

    print('📂 ${_categories.length} kategori bulundu');
    notifyListeners();
  }

  // Kategori seç
  void selectCategory(String? category) {
    if (_selectedCategory == category) {
      // Aynı kategoriye tıklandıysa, filtreyi kaldır
      _selectedCategory = null;
    } else {
      _selectedCategory = category;
    }
    
    print('🏷️ Seçili kategori: ${_selectedCategory ?? "Tümü"}');
    notifyListeners();
  }

  // Filtreyi temizle
  void clearFilter() {
    _selectedCategory = null;
    notifyListeners();
  }

  // Kategori adını kısalt (UI için)
  String getShortCategoryName(String category) {
    // "GG1 - PİLİÇ PİŞMİŞ DNR" -> "PİLİÇ PİŞMİŞ DNR"
    if (category.contains(' - ')) {
      return category.split(' - ').last;
    }
    return category;
  }

  // Kategori ikonu (emoji veya icon name)
  String getCategoryIcon(String category) {
    final lowerCategory = category.toLowerCase();
    
    if (lowerCategory.contains('pilİç') || lowerCategory.contains('tavuk')) {
      return '🍗';
    } else if (lowerCategory.contains('süt') || lowerCategory.contains('peynİr')) {
      return '🧀';
    } else if (lowerCategory.contains('turşu')) {
      return '🥒';
    } else if (lowerCategory.contains('baharat')) {
      return '🌶️';
    } else if (lowerCategory.contains('sos')) {
      return '🥫';
    } else if (lowerCategory.contains('yağ') || lowerCategory.contains('zeytİn')) {
      return '🫒';
    } else if (lowerCategory.contains('patates')) {
      return '🥔';
    } else if (lowerCategory.contains('sebze')) {
      return '🥬';
    } else if (lowerCategory.contains('unlu') || lowerCategory.contains('ekmek')) {
      return '🍞';
    } else if (lowerCategory.contains('baklİyat')) {
      return '🫘';
    } else if (lowerCategory.contains('konserve')) {
      return '🥫';
    } else {
      return '📦'; // Default
    }
  }

  // Reset
  void reset() {
    _categories = [];
    _selectedCategory = null;
    _categoryProductCount = {};
    notifyListeners();
  }
}