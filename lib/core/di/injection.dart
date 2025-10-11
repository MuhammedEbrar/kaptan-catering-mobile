import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/product_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // SharedPreferences (async olduğu için await ile)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // API Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // DataSources
  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSource(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ProductDataSource>(
    () => ProductDataSource(getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      getIt<AuthDataSource>(),
      getIt<FlutterSecureStorage>(),
    ),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(
      getIt<ProductDataSource>(),
      getIt<SharedPreferences>(),
    ),
  );

  print('✅ Dependency Injection kurulumu tamamlandı');
}