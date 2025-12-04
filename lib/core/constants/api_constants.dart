class ApiConstants {
  // Base URLs
  static const String baseUrlLocal = 'http://localhost:3000/api';
  static const String baseUrlProduction =
      'https://kaptan-foodv3.vercel.app/api';

  // Şu an hangisini kullanacağız
  static const String baseUrl =
      baseUrlProduction; // TODO: Local'de test ederken değiştir

  // Mock Mode Flag
  static const bool isMockMode = true;
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String me = '/auth/me';
  static const String updateProfile = '/auth/update-profile';
  static const String changePassword = '/auth/change-password';

  // Product Endpoints
  static const String products = '/products';

  // Order Endpoints
  static const String orders = '/siparisler';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
