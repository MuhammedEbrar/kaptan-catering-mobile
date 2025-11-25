import 'dart:convert';

class ProductModel {
  final String id;
  final int categoryId;
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
    required this.categoryId,
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
      categoryId: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      // Backend: stock_code, name, category_id, unit, image_url
      stokKodu: json['stock_code']?.toString() ?? '',
      stokAdi: json['name']?.toString() ?? '',
      kategori: json['category_name']?.toString() ?? '', // Mapped category_name to kategori
      birim: json['unit']?.toString() ?? 'AD',
      fotografUrl: json['image_url']?.toString(),
      // Fiyat string gelebilir, güvenli parse
      fiyat: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      kdvDahil: json['kdv_dahil'] ?? true,
      kdvOrani: double.tryParse(json['kdv_orani']?.toString() ?? '18') ?? 18.0,
      // Stok miktarı
      stokMiktari: int.tryParse(json['stock_quantity']?.toString() ?? '100') ?? 100,
      minSiparisMiktari: int.tryParse(json['min_order_quantity']?.toString() ?? '1') ?? 1,
      aciklama: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'stock_code': stokKodu,
      'name': stokAdi,
      'category_name': kategori,
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