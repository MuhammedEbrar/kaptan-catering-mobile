import 'dart:convert';

class OrderModel {
  final String? id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String deliveryAddress;
  final String? deliveryPhone;
  final String? orderNote;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    this.deliveryPhone,
    this.orderNote,
    required this.createdAt,
    this.updatedAt,
  });

  // JSON Serialization
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString(),
      userId: json['userId']?.toString() ?? json['user_id']?.toString() ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? json['total_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? json['payment_method'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? json['delivery_address'] ?? '',
      deliveryPhone: json['deliveryPhone'] ?? json['delivery_phone'],
      orderNote: json['orderNote'] ?? json['order_note'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      if (deliveryPhone != null) 'deliveryPhone': deliveryPhone,
      if (orderNote != null) 'orderNote': orderNote,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // String'e çevir
  String toJsonString() => json.encode(toJson());

  // String'den oluştur
  factory OrderModel.fromJsonString(String jsonString) {
    return OrderModel.fromJson(json.decode(jsonString));
  }

  // Sipariş durumları
  static const String statusPending = 'pending'; // Ödeme bekliyor
  static const String statusPaid = 'paid'; // Ödendi
  static const String statusPreparing = 'preparing'; // Hazırlanıyor
  static const String statusShipped = 'shipped'; // Kargoya verildi
  static const String statusDelivered = 'delivered'; // Teslim edildi
  static const String statusCancelled = 'cancelled'; // İptal edildi

  // Durum görünen adı
  String getStatusDisplayName() {
    switch (status) {
      case 'pending':
        return 'Ödeme Bekliyor';
      case 'paid':
        return 'Ödeme Alındı';
      case 'preparing':
        return 'Hazırlanıyor';
      case 'shipped':
        return 'Kargoya Verildi';
      case 'delivered':
        return 'Teslim Edildi';
      case 'cancelled':
        return 'İptal Edildi';
      default:
        return status;
    }
  }

  // Ödeme yöntemleri
  static const String paymentIyzico = 'iyzico';
  static const String paymentCashOnDelivery = 'cash_on_delivery';

  // Ödeme yöntemi görünen adı
  String getPaymentMethodDisplayName() {
    switch (paymentMethod) {
      case 'iyzico':
        return 'Kredi Kartı (İyzico)';
      case 'cash_on_delivery':
        return 'Kapıda Ödeme';
      default:
        return paymentMethod;
    }
  }

  // Toplam ürün sayısı
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  // Copy with
  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    double? totalAmount,
    String? status,
    String? paymentMethod,
    String? deliveryAddress,
    String? deliveryPhone,
    String? orderNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryPhone: deliveryPhone ?? this.deliveryPhone,
      orderNote: orderNote ?? this.orderNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// OrderItem Model (Sipariş içindeki ürün)
class OrderItem {
  final String productId;
  final String productName;
  final String productCode;
  final int quantity;
  final String unit;
  final double price;
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId']?.toString() ?? json['product_id']?.toString() ?? '',
      productName: json['productName'] ?? json['product_name'] ?? '',
      productCode: json['productCode'] ?? json['product_code'] ?? '',
      quantity: json['quantity'] ?? 1,
      unit: json['unit'] ?? 'AD',
      price: (json['price'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? json['total_price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'totalPrice': totalPrice,
    };
  }

  // CartItem'dan OrderItem oluştur
  factory OrderItem.fromCartItem(dynamic cartItem) {
    return OrderItem(
      productId: cartItem.product.id,
      productName: cartItem.product.stokAdi,
      productCode: cartItem.product.stokKodu,
      quantity: cartItem.quantity,
      unit: cartItem.product.birim,
      price: cartItem.product.fiyat,
      totalPrice: cartItem.getTotalPrice(),
    );
  }
}