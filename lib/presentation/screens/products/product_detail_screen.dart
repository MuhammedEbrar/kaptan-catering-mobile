import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isKdvIncluded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFavorite
                      ? 'Favorilere eklendi!'
                      : 'Favorilerden çıkarıldı!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Resmi
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            ),

            // Stok Kodu Badge
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'SKU: AYR00001',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Ürün Bilgileri
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '170 CC TEKSÖT YARIM YAĞLI AYRAN 20Lİ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('SÜT ÜRÜNLERİ'),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.check_circle, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'Stokta Var',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fiyat Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '₺99.99',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Row(
                            children: [
                              const Text('KDV Dahil'),
                              Switch(
                                value: _isKdvIncluded,
                                onChanged: (value) {
                                  setState(() {
                                    _isKdvIncluded = value;
                                  });
                                },
                                activeColor: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Birim: AD',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Miktar Seçici
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Miktar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 32,
                        color: Colors.red,
                      ),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_quantity',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 32,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'AD',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // Sepete Ekle Butonu (Sticky Bottom)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$_quantity adet sepete eklendi!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Sepete Ekle - ₺${(99.99 * _quantity).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}