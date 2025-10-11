import 'dart:convert';

class ProductModel {
  final String id;
  final String stokKodu;
  final String stokAdi;
  final String kategori;
  final String birim;
  final String? fotografUrl;
  final double fiyat;
  final bool kdvDahil;
  final double kdvOrani;
  final int stokMiktari;
  final int? minSiparisMiktari;
  final String? aciklama;

  ProductModel({
    required this.id,
    required this.stokKodu,
    required this.stokAdi,
    required this.kategori,
    required this.birim,
    this.fotografUrl,
    required this.fiyat,
    this.kdvDahil = true,
    this.kdvOrani = 18.0,
    required this.stokMiktari,
    this.minSiparisMiktari,
    this.aciklama,
  });

  // Fiyat hesaplamaları
  double getFiyatKdvHaric() {
    if (kdvDahil) {
      return fiyat / (1 + (kdvOrani / 100));
    }
    return fiyat;
  }

  double getFiyatKdvDahil() {
    if (!kdvDahil) {
      return fiyat * (1 + (kdvOrani / 100));
    }
    return fiyat;
  }

  double getKdvTutari() {
    return getFiyatKdvDahil() - getFiyatKdvHaric();
  }

  // JSON Serialization - BACKEND FORMATINA UYARLANMIŞ
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      // Backend: stock_code, name, category_id, unit, image_url
      stokKodu: json['stock_code'] ?? '',
      stokAdi: json['name'] ?? '',
      kategori: json['category_id'] ?? '',
      birim: json['unit'] ?? 'AD',
      fotografUrl: json['image_url'],
      // Fiyat backend'de yok, geçici 0 (sonra eklenecek)
      fiyat: (json['price'] ?? json['fiyat'] ?? 0).toDouble(),
      kdvDahil: json['kdv_dahil'] ?? true,
      kdvOrani: (json['kdv_orani'] ?? 18).toDouble(),
      // Stok miktarı backend'de yok, geçici 100
      stokMiktari: json['stock_quantity'] ?? json['stok_miktari'] ?? 100,
      minSiparisMiktari: json['min_order_quantity'] ?? json['min_siparis_miktari'],
      aciklama: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock_code': stokKodu,
      'name': stokAdi,
      'category_id': kategori,
      'unit': birim,
      'image_url': fotografUrl,
      'price': fiyat,
      'kdv_dahil': kdvDahil,
      'kdv_orani': kdvOrani,
      'stock_quantity': stokMiktari,
      'min_order_quantity': minSiparisMiktari,
      'description': aciklama,
    };
  }

  String toJsonString() => json.encode(toJson());

  factory ProductModel.fromJsonString(String jsonString) {
    return ProductModel.fromJson(json.decode(jsonString));
  }

  bool get stokVarMi => stokMiktari > 0;
  bool get isActive => true; // Backend'den is_active kontrolü yapılabilir
}