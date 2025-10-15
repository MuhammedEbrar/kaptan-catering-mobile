import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../auth/login_screen.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Ürünleri yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      final categoryProvider = context.read<CategoryProvider>();
      
      productProvider.loadProducts().then((_) {
        categoryProvider.extractCategories(productProvider.products);
      });
    });

    // Scroll listener ekle
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final productProvider = context.read<ProductProvider>();
    
    // Scroll sonuna yakın mı? (80% scroll olduğunda yükle)
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      
      // Yükleme devam ediyorsa veya daha fazla ürün yoksa çık
      if (productProvider.isLoadingMore || !productProvider.hasMore) return;
      
      // Filtreleme varsa pagination yapma
      if (productProvider.searchQuery.isNotEmpty || 
          productProvider.selectedCategory != null) return;

      // Daha fazla ürün yükle
      productProvider.loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaptan Catering'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Kullanıcı bilgileri
          if (user != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.backgroundLight,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.companyName ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Arama Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ürün ara... (Stok kodu veya ürün adı)',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          productProvider.searchProducts('');
                          FocusScope.of(context).unfocus();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                productProvider.searchProducts(value);
                if (value.isNotEmpty && categoryProvider.hasSelectedCategory) {
                  categoryProvider.clearFilter();
                }
                setState(() {});
              },
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),

          // Kategori Filtreleme Chips
          if (categoryProvider.categories.isNotEmpty && productProvider.searchQuery.isEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              : AppColors.textPrimary,
                        ),
                      ),
                    );
                  }

                  final category = categoryProvider.categories[index - 1];
                  final isSelected = categoryProvider.selectedCategory == category;
                  final shortName = categoryProvider.getShortCategoryName(category);
                  final icon = categoryProvider.getCategoryIcon(category);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(icon),
                          const SizedBox(width: 4),
                          Text(shortName),
                        ],
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
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Ürün listesi
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productProvider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 60,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                productProvider.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.error),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                productProvider.loadProducts(forceRefresh: true);
                              },
                              child: const Text('Tekrar Dene'),
                            ),
                          ],
                        ),
                      )
                    : productProvider.productCount == 0
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  productProvider.searchQuery.isNotEmpty
                                      ? 'Ürün bulunamadı'
                                      : 'Henüz ürün yok',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: productProvider.productCount + 
                                       (productProvider.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              // Loading indicator
                              if (index == productProvider.productCount) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final product = productProvider.products[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: product.fotografUrl != null
                                      ? Image.network(
                                          product.fotografUrl!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                          ),
                                        )
                                      : Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundLight,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              categoryProvider.getCategoryIcon(product.kategori),
                                              style: const TextStyle(fontSize: 24),
                                            ),
                                          ),
                                        ),
                                  title: Text(
                                    product.stokAdi,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text('Stok Kodu: ${product.stokKodu}'),
                                      Text(
                                        categoryProvider.getShortCategoryName(product.kategori),
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text('Birim: ${product.birim}'),
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
          ),

          // Ürün sayısı ve durum
          if (!productProvider.isLoading && productProvider.productCount > 0)
            Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.backgroundLight,
              child: Column(
                children: [
                  Text(
                    categoryProvider.hasSelectedCategory
                        ? '${productProvider.productCount} ürün (${categoryProvider.getShortCategoryName(categoryProvider.selectedCategory!)})'
                        : productProvider.searchQuery.isNotEmpty
                            ? '${productProvider.productCount} ürün bulundu'
                            : '${productProvider.productCount} ürün',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (!productProvider.hasMore && 
                      productProvider.searchQuery.isEmpty &&
                      !categoryProvider.hasSelectedCategory)
                    const Text(
                      'Tüm ürünler yüklendi',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textLight,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}