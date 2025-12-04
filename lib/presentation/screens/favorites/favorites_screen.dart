import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorilerim'),
        backgroundColor: AppColors.primary,
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, _) {
              if (favoriteProvider.favorites.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  _showClearFavoritesDialog(context, favoriteProvider);
                },
                tooltip: 'Tümünü Temizle',
              );
            },
          ),
        ],
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          if (favoriteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoriteProvider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Favori Listeniz Boş',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Beğendiğiniz ürünleri buraya ekleyebilirsiniz',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favoriteProvider.favorites.length,
            itemBuilder: (context, index) {
              final product = favoriteProvider.favorites[index];
              return ProductCard(
                product: product,
                onTap: () {
                  // Ürün detayına git (şimdilik boş veya dialog)
                  // İleride ProductDetailScreen eklenebilir
                },
                onAddToCart: () {
                  final authProvider = context.read<AuthProvider>();
                  if (!authProvider.isLoggedIn) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Giriş Yapmanız Gerekiyor'),
                        content: const Text(
                            'Sepete ürün ekleyebilmek için giriş yapmanız veya kayıt olmanız gerekmektedir.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('İptal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text('Kayıt Ol'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Giriş Yap'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  context.read<CartProvider>().addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.stokAdi} sepete eklendi'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                onToggleFavorite: () {
                  favoriteProvider.toggleFavorite(product);
                },
                isFavorite: true,
              );
            },
          );
        },
      ),
    );
  }

  void _showClearFavoritesDialog(
      BuildContext context, FavoriteProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Favorileri Temizle'),
        content: const Text(
            'Tüm favori ürünlerinizi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              provider.clearFavorites();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Favoriler temizlendi'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text(
              'Temizle',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
