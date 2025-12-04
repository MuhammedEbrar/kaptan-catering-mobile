import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

import '../screens/main_screen.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock kategoriler (Gerçek veriler gelene kadar veya ikonlu gösterim için)
    final List<Map<String, dynamic>> categories = [
      {'name': 'Et Ürünleri', 'icon': Icons.restaurant, 'id': 'et'},
      {'name': 'Süt & Kahvaltılık', 'icon': Icons.egg_alt, 'id': 'sut'},
      {'name': 'İçecekler', 'icon': Icons.local_drink, 'id': 'icecek'},
      {'name': 'Bakliyat', 'icon': Icons.grass, 'id': 'bakliyat'},
      {'name': 'Temizlik', 'icon': Icons.cleaning_services, 'id': 'temizlik'},
      {'name': 'Ambalaj', 'icon': Icons.inventory_2, 'id': 'ambalaj'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kategoriler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  mainScreenKey.currentState?.changeTab(1); // Ürünler sekmesi
                },
                child: const Text('Tümü'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () {
                    // Kategori seçimi ve yönlendirme

                    // Mock kategori objesi oluşturup filtreleme yapıyoruz
                    // Not: Gerçek uygulamada ID eşleşmesi yapılmalı
                    // Şimdilik sadece ürünler sayfasına yönlendiriyoruz
                    mainScreenKey.currentState?.changeTab(1);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          cat['icon'] as IconData,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat['name'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
