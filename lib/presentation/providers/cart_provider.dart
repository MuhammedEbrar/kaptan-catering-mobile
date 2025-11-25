import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  CartProvider(this._prefs) {
    _loadCartFromStorage();
  }

  // States
  List<CartItem> _items = [];
  bool _isLoading = false;

  // Storage key
  static const String _cartKey = 'shopping_cart';

  // Getters
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.length;
  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  // Sepete ürün ekle
  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    // Minimum sipariş miktarı kontrolü
    if (product.minSiparisMiktari != null && quantity < product.minSiparisMiktari!) {
      throw 'Minimum sipariş miktarı: ${product.minSiparisMiktari} ${product.birim}';
    }

    // Ürün zaten sepette var mı?
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Varsa miktarı artır
      _items[existingIndex].quantity += quantity;
      print('🛒 Sepetteki ürün miktarı artırıldı: ${product.stokAdi} (${_items[existingIndex].quantity})');
    } else {
      // Yoksa yeni ekle
      _items.add(CartItem(
        product: product,
        quantity: quantity,
      ));
      print('🛒 Sepete ürün eklendi: ${product.stokAdi} (${quantity})');
    }

    await _saveCartToStorage();
    notifyListeners();
  }

  // Sepetten ürün çıkar
  Future<void> removeFromCart(String productId) async {
    final removedItem = _items.firstWhere((item) => item.product.id == productId);
    _items.removeWhere((item) => item.product.id == productId);
    
    print('🗑️ Sepetten ürün çıkarıldı: ${removedItem.product.stokAdi}');
    
    await _saveCartToStorage();
    notifyListeners();
  }

  // Ürün miktarını güncelle
  Future<void> updateQuantity(String productId, int newQuantity) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    
    if (index < 0) return;

    final item = _items[index];

    // Minimum miktar kontrolü
    if (item.product.minSiparisMiktari != null && 
        newQuantity < item.product.minSiparisMiktari!) {
      throw 'Minimum sipariş miktarı: ${item.product.minSiparisMiktari} ${item.product.birim}';
    }

    // Sıfırdan küçük olamaz
    if (newQuantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    _items[index].quantity = newQuantity;
    print('🔄 Ürün miktarı güncellendi: ${item.product.stokAdi} (${newQuantity})');
    
    await _saveCartToStorage();
    notifyListeners();
  }

  // Miktarı artır
  Future<void> incrementQuantity(String productId) async {
    final item = _items.firstWhere((item) => item.product.id == productId);
    await updateQuantity(productId, item.quantity + 1);
  }

  // Miktarı azalt
  Future<void> decrementQuantity(String productId) async {
    final item = _items.firstWhere((item) => item.product.id == productId);
    await updateQuantity(productId, item.quantity - 1);
  }

  // Sepeti temizle
  Future<void> clearCart() async {
    _items.clear();
    await _saveCartToStorage();
    notifyListeners();
    print('🗑️ Sepet temizlendi');
  }

  // Ara toplam (KDV hariç)
  double getSubtotal() {
    return _items.fold(0.0, (sum, item) => sum + item.product.getFiyatKdvHaric() * item.quantity);
  }

  // KDV tutarı
  double getKdvAmount() {
    return _items.fold(0.0, (sum, item) => sum + item.getKdvAmount());
  }

  // Kargo ücreti (şimdilik sabit, ileride dinamik olabilir)
  double getShippingCost() {
    // Belirli bir tutarın üstünde ücretsiz kargo
    const double freeShippingThreshold = 500.0;
    const double shippingCost = 50.0;

    final total = getGrandTotal();
    return total >= freeShippingThreshold ? 0.0 : shippingCost;
  }

  // Genel toplam (KDV dahil + kargo)
  double getGrandTotal() {
    return getSubtotal() + getKdvAmount();
  }

  // Final toplam (kargo dahil)
  double getFinalTotal() {
    return getGrandTotal() + getShippingCost();
  }

  // Ürün sepette mi?
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Sepetteki ürün miktarını getir
  int getQuantityInCart(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: ProductModel(
        id: '',
        categoryId: 0,
        stokKodu: '',
        stokAdi: '',
        kategori: '',
        birim: '',
        fiyat: 0,
        stokMiktari: 0,
      ), quantity: 0),
    );
    return item.quantity;
  }

  // Local storage'a kaydet
  Future<void> _saveCartToStorage() async {
    try {
      final cartJson = _items.map((item) => item.toJson()).toList();
      final jsonString = json.encode(cartJson);
      await _prefs.setString(_cartKey, jsonString);
      print('💾 Sepet kaydedildi (${_items.length} ürün)');
    } catch (e) {
      print('❌ Sepet kaydetme hatası: $e');
    }
  }

  // Local storage'dan yükle
  Future<void> _loadCartFromStorage() async {
    try {
      _isLoading = true;
      notifyListeners();

      final jsonString = _prefs.getString(_cartKey);
      if (jsonString == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final List<dynamic> cartJson = json.decode(jsonString);
      _items = cartJson.map((json) => CartItem.fromJson(json)).toList();
      
      print('📦 Sepet yüklendi (${_items.length} ürün)');
    } catch (e) {
      print('❌ Sepet yükleme hatası: $e');
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sepet validasyonu (sipariş öncesi)
  List<String> validateCart() {
    final errors = <String>[];

    if (_items.isEmpty) {
      errors.add('Sepetiniz boş');
      return errors;
    }

    for (var item in _items) {
      // Stok kontrolü
      if (!item.product.stokVarMi) {
        errors.add('${item.product.stokAdi} stokta yok');
      }

      // Minimum miktar kontrolü
      if (!item.isValidQuantity()) {
        errors.add('${item.product.stokAdi} için minimum ${item.product.minSiparisMiktari} ${item.product.birim} gerekli');
      }
    }

    return errors;
  }

  // Reset
  void reset() {
    _items = [];
    _isLoading = false;
    notifyListeners();
  }
}