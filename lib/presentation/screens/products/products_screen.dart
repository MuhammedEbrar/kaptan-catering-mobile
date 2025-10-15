import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/cart_provider.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      final categoryProvider = context.read<CategoryProvider>();

      if (productProvider.products.isEmpty) {
        productProvider.loadProducts().then((_) {
          categoryProvider.extractCategories(productProvider.products);
        });
      } else {
        categoryProvider.extractCategories(productProvider.products);
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final productProvider = context.read<ProductProvider>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (productProvider.isLoadingMore || !productProvider.hasMore) return;
      if (productProvider.searchQuery.isNotEmpty ||
          productProvider.selectedCategory != null) return;

      productProvider.loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        backgroundColor: AppColors.primary,
        actions: [
          // 🆕 Cache info butonu (debug için)
          if (productProvider.isOffline)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showCacheInfo(context),
              tooltip: 'Önbellek Bilgisi',
            ),
        ],
      ),
      body: Column(
        children: [
          // 🆕 Offline Banner
          if (productProvider.isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.orange.shade900, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Çevrimdışı mod - Önbellekteki ürünler gösteriliyor',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await productProvider.checkConnectivityAndRefresh();
                    },
                    child: Text(
                      'Yenile',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Arama barı
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          productProvider.searchProducts('');
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                productProvider.searchProducts(value);
                if (value.isNotEmpty && categoryProvider.hasSelectedCategory) {
                  categoryProvider.clearFilter();
                }
                setState(() {});
              },
            ),
          ),

          // Kategori chips
          if (categoryProvider.categories.isNotEmpty &&
              productProvider.searchQuery.isEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryProvider.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('Tümü'),
                        selected: !categoryProvider.hasSelectedCategory,
                        onSelected: (_) {
                          categoryProvider.clearFilter();
                          productProvider.filterByCategory(null);
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: !categoryProvider.hasSelectedCategory
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  }

                  final category = categoryProvider.categories[index - 1];
                  final isSelected =
                      categoryProvider.selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        categoryProvider.getShortCategoryName(category),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        categoryProvider.selectCategory(category);
                        productProvider.filterByCategory(
                          categoryProvider.selectedCategory,
                        );
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Ürün grid
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productProvider.productCount == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              productProvider.isOffline 
                                  ? Icons.wifi_off 
                                  : Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              productProvider.isOffline
                                  ? 'Çevrimdışı modda ürün yok'
                                  : 'Ürün bulunamadı',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (productProvider.isOffline) ...[
                              const SizedBox(height: 8),
                              Text(
                                'İnternet bağlantınızı kontrol edin',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await productProvider.checkConnectivityAndRefresh();
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Yeniden Dene'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        // 🆕 Pull to refresh
                        onRefresh: () async {
                          await productProvider.checkConnectivityAndRefresh();
                          if (!productProvider.isOffline) {
                            categoryProvider.extractCategories(
                              productProvider.products,
                            );
                          }
                        },
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: productProvider.productCount +
                              (productProvider.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == productProvider.productCount) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final product = productProvider.products[index];
                            final isInCart = cartProvider.isInCart(product.id);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Ürün resmi
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
                                            size: 48,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Ürün bilgileri
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.stokAdi,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.birim,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          // Sepete ekle butonu
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: () async {
                                                try {
                                                  if (isInCart) {
                                                    await cartProvider
                                                        .removeFromCart(
                                                            product.id);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Sepetten çıkarıldı'),
                                                          duration:
                                                              Duration(seconds: 1),
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    await cartProvider.addToCart(
                                                      product,
                                                      quantity: 1,
                                                    );
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Sepete eklendi'),
                                                          duration:
                                                              Duration(seconds: 1),
                                                          backgroundColor:
                                                              AppColors.success,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                } catch (e) {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            e.toString()),
                                                        backgroundColor:
                                                            AppColors.error,
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                              icon: Icon(
                                                isInCart
                                                    ? Icons.shopping_cart
                                                    : Icons.add_shopping_cart,
                                                size: 18,
                                              ),
                                              label: Text(
                                                isInCart
                                                    ? 'Sepette'
                                                    : 'Sepete Ekle',
                                                style:
                                                    const TextStyle(fontSize: 12),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isInCart
                                                    ? AppColors.textSecondary
                                                    : AppColors.primary,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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

  // 🆕 Cache bilgisi göster (debug için)
  Future<void> _showCacheInfo(BuildContext context) async {
    final productProvider = context.read<ProductProvider>();
    final cacheInfo = await productProvider.getCacheInfo();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Önbellek Bilgisi'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Durum', cacheInfo['isOnline'] ? '🟢 Online' : '🔴 Offline'),
            _buildInfoRow('Bağlantı', cacheInfo['connectionType']),
            _buildInfoRow('Önbellekte Ürün', '${cacheInfo['cachedProductCount']}'),
            _buildInfoRow('Önbellek Geçerli', cacheInfo['isCacheValid'] ? 'Evet' : 'Hayır'),
            if (cacheInfo['cacheAge'] != null)
              _buildInfoRow('Önbellek Yaşı', '${cacheInfo['cacheAge']} saat'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}