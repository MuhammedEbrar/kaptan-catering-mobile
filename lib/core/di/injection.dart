import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // API Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // DataSources
  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSource(getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      getIt<AuthDataSource>(),
      getIt<FlutterSecureStorage>(),
    ),
  );
}