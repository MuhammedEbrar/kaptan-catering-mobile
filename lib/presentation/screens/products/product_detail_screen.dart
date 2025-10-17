import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/success_animation.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final String heroTag;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final isInCart = cartProvider.isInCart(widget.product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.stokAdi,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.primary,
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final isFavorite = favoriteProvider.isFavorite(widget.product.id);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () async {
                  await favoriteProvider.toggleFavorite(widget.product);

                  if (context.mounted) {
                    CustomSnackBar.success(
                      context,
                      isFavorite ? 'Favorilerden çıkarıldı' : 'Favorilere eklendi!',
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Resmi (Hero animation)
            Hero(
              tag: widget.heroTag,
              child: Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[200],
                child: Center(
                  child: Icon(
                    Icons.fastfood,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stok Kodu Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Stok Kodu: ${widget.product.stokKodu}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Ürün Adı
                  Text(
                    widget.product.stokAdi,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Kategori ve Birim
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(widget.product.kategori),
                        backgroundColor: Colors.orange[100],
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                      Chip(
                        label: Text('Birim: ${widget.product.birim}'),
                        backgroundColor: Colors.blue[100],
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stok Durumu
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Stokta Var',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Miktar Seçici
                  const Text(
                    'Miktar:',
                    style: TextStyle(
                      fontSize: 16,
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
                        color: AppColors.primary,
                        iconSize: 32,
                      ),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_quantity ${widget.product.birim}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
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
                        color: AppColors.primary,
                        iconSize: 32,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Sepete Ekle Butonu (Animated)
                  AnimatedButton(
                    width: double.infinity,
                    height: 56,
                    backgroundColor: isInCart 
                        ? AppColors.textSecondary 
                        : AppColors.primary,
                    onPressed: () async {
                      try {
                        if (isInCart) {
                          await cartProvider.removeFromCart(widget.product.id);
                          if (mounted) {
                            CustomSnackBar.info(context, 'Sepetten çıkarıldı');
                          }
                        } else {
                          await cartProvider.addToCart(
                            widget.product,
                            quantity: _quantity,
                          );
                          if (mounted) {
                            // Success animation göster
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black54,
                              builder: (context) => Center(
                                child: SuccessAnimation(
                                  onComplete: () {
                                    Navigator.pop(context);
                                    CustomSnackBar.success(context, 'Sepete eklendi!');
                                  },
                                ),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          CustomSnackBar.error(context, e.toString());
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isInCart ? 'Sepetten Çıkar' : 'Sepete Ekle',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Ürün Açıklaması
                  ExpansionTile(
                    title: const Text(
                      'Ürün Detayları',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Bu ürün hakkında detaylı bilgi buraya eklenecek.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Benzer Ürünler
                  const Text(
                    'Benzer Ürünler',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _buildSimilarProductCard(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimilarProductCard(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            CustomSnackBar.info(context, 'Ürün detayı açılıyor...');
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ürün Resmi
              Container(
                height: 100,
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
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              // Ürün Bilgileri
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.kategori,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.birim,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        Icon(
                          Icons.add_shopping_cart,
                          size: 16,
                          color: Colors.red[400],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}