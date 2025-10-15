import 'dart:convert';
import 'product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  // Toplam fiyat (miktar x birim fiyat)
  double getTotalPrice() {
    return product.fiyat * quantity;
  }

  // KDV tutarı
  double getKdvAmount() {
    return product.getKdvTutari() * quantity;
  }

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  // String'e çevir (local storage için)
  String toJsonString() => json.encode(toJson());

  // String'den oluştur
  factory CartItem.fromJsonString(String jsonString) {
    return CartItem.fromJson(json.decode(jsonString));
  }

  // Minimum sipariş miktarı kontrolü
  bool isValidQuantity() {
    if (product.minSiparisMiktari != null) {
      return quantity >= product.minSiparisMiktari!;
    }
    return quantity > 0;
  }

  // Copy with
  CartItem copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}