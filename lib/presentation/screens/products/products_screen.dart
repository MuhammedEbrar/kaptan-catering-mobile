import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/shimmer_product_card.dart';
import 'product_detail_screen.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';

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
          // Kategorileri tüm ürünlerden çek (background fetch tamamlanınca güncellenecek)
          categoryProvider
              .extractCategories(productProvider.allProductsForCategories);
        });
      } else {
        categoryProvider
            .extractCategories(productProvider.allProductsForCategories);
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
          productProvider.selectedCategory != null) {
        return;
      }

      productProvider.loadMoreProducts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Background fetch tamamlandığında kategorileri güncelle
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.read<CategoryProvider>();

    if (productProvider.allProductsForCategories.isNotEmpty &&
        productProvider.allProductsForCategories.length >
            productProvider.products.length) {
      // Sadece yeni veri geldiyse güncelle
      categoryProvider
          .extractCategories(productProvider.allProductsForCategories);
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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header (Ana Sayfa ile Birebir Aynı)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/kaptan_logo_new.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  // Giriş/Kayıt Butonları veya Offline İkonu
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.isLoggedIn) {
                        return productProvider.isOffline
                            ? IconButton(
                                icon: const Icon(Icons.info_outline,
                                    color: Colors.orange),
                                onPressed: () => _showCacheInfo(context),
                              )
                            : const SizedBox.shrink();
                      }
                      return Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Giriş Yap',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Kayıt Ol'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Arama Barı (Header'ın Altında)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Ürün ara...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            productProvider.searchProducts('');
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) {
                  productProvider.searchProducts(value);
                  if (value.isNotEmpty &&
                      categoryProvider.hasSelectedCategory) {
                    categoryProvider.clearFilter();
                  }
                  setState(() {});
                },
              ),
            ),

            // Offline Banner
            if (productProvider.isOffline)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.only(top: 8),
                color: Colors.orange.shade50,
                child: Row(
                  children: [
                    Icon(Icons.wifi_off,
                        color: Colors.orange.shade900, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Çevrimdışı moddasınız',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await productProvider.checkConnectivityAndRefresh();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Yenile',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Kategoriler
            if (categoryProvider.categories.isNotEmpty &&
                productProvider.searchQuery.isEmpty)
              Container(
                height: 60,
                margin: const EdgeInsets.only(top: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categoryProvider.categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
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
                                : Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: !categoryProvider.hasSelectedCategory
                                  ? Colors.transparent
                                  : Colors.grey[300]!,
                            ),
                          ),
                        ),
                      );
                    }

                    final category = categoryProvider.categories[index - 1];
                    final isSelected =
                        categoryProvider.selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
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
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey[300]!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Ürün Listesi
            Expanded(
              child: productProvider.isLoading
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) =>
                          const ShimmerProductCard(),
                    )
                  : productProvider.productCount == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                productProvider.isOffline
                                    ? Icons.wifi_off
                                    : Icons.search_off,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                productProvider.isOffline
                                    ? 'Çevrimdışı modda ürün yok'
                                    : 'Ürün bulunamadı',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (productProvider.isOffline) ...[
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () async {
                                    await productProvider
                                        .checkConnectivityAndRefresh();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Yeniden Dene'),
                                ),
                              ],
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await productProvider.checkConnectivityAndRefresh();
                            if (!productProvider.isOffline) {
                              categoryProvider.extractCategories(
                                productProvider.products,
                              );
                            }
                          },
                          color: AppColors.primary,
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
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
                              final isInCart =
                                  cartProvider.isInCart(product.id);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(
                                        product: product,
                                        heroTag: 'product_${product.id}',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Resim Alanı
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Hero(
                                              tag: 'product_${product.id}',
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(16),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.fastfood,
                                                    size: 48,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.favorite_border,
                                                  size: 18,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Bilgi Alanı
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
                                                height: 1.2,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              product.birim,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            if (isInCart)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  _buildQtyBtn(
                                                    Icons.remove,
                                                    () => cartProvider
                                                        .decrementQuantity(
                                                            product.id),
                                                  ),
                                                  Text(
                                                    '${cartProvider.getQuantityInCart(product.id)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  _buildQtyBtn(
                                                    Icons.add,
                                                    () => cartProvider
                                                        .incrementQuantity(
                                                            product.id),
                                                    isAdd: true,
                                                  ),
                                                ],
                                              )
                                            else
                                              SizedBox(
                                                width: double.infinity,
                                                height: 36,
                                                child: ElevatedButton(
                                                  onPressed: () => _addToCart(
                                                      context,
                                                      cartProvider,
                                                      product),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    elevation: 0,
                                                  ),
                                                  child: const Text(
                                                    'Sepete Ekle',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
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
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap, {bool isAdd = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: isAdd ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isAdd ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Future<void> _addToCart(
      BuildContext context, CartProvider cartProvider, product) async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isLoggedIn) {
      _showLoginDialog(context);
      return;
    }

    try {
      await cartProvider.addToCart(product, quantity: 1);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sepete eklendi'),
            duration: Duration(seconds: 1),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Giriş Yapmanız Gerekiyor'),
        content: const Text(
            'Sepete ürün ekleyebilmek için giriş yapmanız gerekmektedir.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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
  }

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
            _buildInfoRow(
                'Durum', cacheInfo['isOnline'] ? '🟢 Online' : '🔴 Offline'),
            _buildInfoRow('Bağlantı', cacheInfo['connectionType']),
            _buildInfoRow(
                'Önbellekte Ürün', '${cacheInfo['cachedProductCount']}'),
            _buildInfoRow('Önbellek Geçerli',
                cacheInfo['isCacheValid'] ? 'Evet' : 'Hayır'),
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
