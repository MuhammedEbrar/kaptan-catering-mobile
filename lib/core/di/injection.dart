import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/product_datasource.dart';
import '../../data/datasources/order_datasource.dart';
import '../../data/datasources/address_datasource.dart'; // 👈 EKLE
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/address_repository.dart'; // 👈 EKLE

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // FlutterSecureStorage
  const storage = FlutterSecureStorage();
  getIt.registerSingleton<FlutterSecureStorage>(storage);

  // ApiClient
  getIt.registerSingleton<ApiClient>(ApiClient());

  // DataSources
  getIt.registerSingleton<AuthDataSource>(
    AuthDataSource(getIt<ApiClient>()),
  );

  getIt.registerSingleton<ProductDataSource>(
    ProductDataSource(getIt<ApiClient>()),
  );

  getIt.registerSingleton<OrderDataSource>(
    OrderDataSource(getIt<ApiClient>()),
  );

  // 👇 YENİ: AddressDataSource
  getIt.registerSingleton<AddressDataSource>(
    AddressDataSource(getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(
      getIt<AuthDataSource>(),
      getIt<FlutterSecureStorage>(),
    ),
  );

  getIt.registerSingleton<ProductRepository>(
    ProductRepository(
      getIt<ProductDataSource>(),
      getIt<SharedPreferences>(),
    ),
  );

  getIt.registerSingleton<OrderRepository>(
    OrderRepository(getIt<OrderDataSource>()),
  );

  // 👇 YENİ: AddressRepository
  getIt.registerSingleton<AddressRepository>(
    AddressRepository(getIt<AddressDataSource>()),
  );
}