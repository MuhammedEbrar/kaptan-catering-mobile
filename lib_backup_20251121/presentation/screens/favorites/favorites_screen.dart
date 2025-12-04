import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/empty_state_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Mock favori ürünler
  final List<Map<String, dynamic>> _favorites = [
    {
      'name': '170 CC TEKSÖT YARIM YAĞLI AYRAN 20Lİ',
      'price': 99.99,
      'unit': 'AD',
      'category': 'SÜT ÜRÜNLERİ',
    },
    {
      'name': '2000GR ÇOBANYILDIZI KAŞAR PEYNİRİ',
      'price': 250.00,
      'unit': 'KG',
      'category': 'SÜT ÜRÜNLERİ',
    },
    {
      'name': '295 ML AYRAN 12 Lİ',
      'price': 45.00,
      'unit': 'AD',
      'category': 'SÜT ÜRÜNLERİ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorilerim (${_favorites.length})'),
        backgroundColor: AppColors.primary,
      ),
      body: _favorites.isEmpty
          ? EmptyStateWidget(
              icon: Icons.favorite_border,
              title: 'Henüz Favori Ürün Yok',
              subtitle:
                  'Beğendiğiniz ürünleri favorilerinize ekleyerek hızlıca ulaşabilirsiniz',
              buttonText: 'Ürünleri Keşfet',
              onButtonPressed: () {
                Navigator.pop(context);
              },
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                return _buildFavoriteCard(_favorites[index], index);
              },
            ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> product, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ürün Resmi
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.fastfood,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(
                        product['category'],
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: Colors.orange[100],
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₺${product['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product['unit'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart, size: 20),
                          color: AppColors.primary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sepete eklendi!'),
                                duration: Duration(seconds: 1),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Favori icon overlay (üstte sağda)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite,
                    color: AppColors.primary, size: 20),
                onPressed: () {
                  setState(() {
                    _favorites.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favorilerden çıkarıldı'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
