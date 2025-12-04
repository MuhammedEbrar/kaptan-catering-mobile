import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
import '../../widgets/home_slider.dart';
import '../../widgets/home_footer.dart';

import '../../widgets/home_categories.dart';
import '../../widgets/featured_products.dart';
import '../../widgets/info_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
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
                  // Giriş/Kayıt Butonları
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      // Giriş yapılmış olsa bile butonları göster (Kullanıcı isteği)
                      /* if (authProvider.isLoggedIn) {
                        return const SizedBox.shrink();
                      } */

                      // Eğer giriş yapılmışsa ve kullanıcı butonları görmek istemiyorsa burayı açabiliriz
                      // Şimdilik her zaman gösteriliyor.

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

            // İçerik
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    // Slider
                    HomeSlider(),

                    SizedBox(height: 24),

                    // Kategoriler
                    HomeCategories(),

                    SizedBox(height: 24),

                    // Öne Çıkanlar
                    FeaturedProducts(),

                    SizedBox(height: 24),

                    // Bilgi Bölümü
                    InfoSection(),

                    SizedBox(height: 32),

                    // Footer
                    HomeFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
