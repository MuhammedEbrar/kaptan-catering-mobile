import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Arama Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Kategori Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('Tümü', true),
                _buildCategoryChip('Pilav', false),
                _buildCategoryChip('Sebze', false),
                _buildCategoryChip('Et', false),
                _buildCategoryChip('Tatlı', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Ürün Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildProductCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (value) {},
        selectedColor: Colors.red,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductDetailScreen(),
          ),
        );
      },
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Resmi
            Container(
              height: 120,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ürün Adı',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '₺99.99',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'KG',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart, size: 20),
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}