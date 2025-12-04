import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_colors.dart';
import 'core/di/injection.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/address_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/category_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/order_provider.dart';
import 'presentation/providers/address_provider.dart';
import 'presentation/providers/favorite_provider.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'core/utils/global_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await setupDependencies();
  
  runApp(const KaptanCateringApp());
}

class KaptanCateringApp extends StatelessWidget {
  const KaptanCateringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(getIt<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(getIt<ProductRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(getIt<SharedPreferences>()),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(getIt<OrderRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(getIt<AddressRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Kaptan Catering',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.primaryLight,
            surface: AppColors.surface,
            error: AppColors.error,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            color: Colors.white,
          ),
        ),
        navigatorKey: navigatorKey,
        routes: {
          '/login': (context) => const LoginScreen(),
        },
        home: const SplashScreen(),
      ),
    );
  }
}