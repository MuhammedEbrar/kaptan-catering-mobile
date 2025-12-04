import 'package:dio/dio.dart';
import 'dart:convert';
import '../constants/api_constants.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Simüle edilmiş ağ gecikmesi
    await Future.delayed(const Duration(milliseconds: 500));

    final path = options.path;

    if (path.contains(ApiConstants.login)) {
      return handler.resolve(
        Response(
          requestOptions: options,
          data: {
            'token': 'mock_token_12345',
            'user': {
              'id': 1,
              'name': 'Test Kullanıcı',
              'email': 'test@kaptan.com',
              'role': 'user'
            }
          },
          statusCode: 200,
        ),
      );
    }

    if (path.contains(ApiConstants.products)) {
      return handler.resolve(
        Response(
          requestOptions: options,
          data: [
            {
              'id': 1,
              'name': 'Mercimek Çorbası',
              'description': 'Sıcak ve lezzetli',
              'price': 45.0,
              'imageUrl': 'https://via.placeholder.com/150',
              'category': 'Çorbalar'
            },
            {
              'id': 2,
              'name': 'Adana Kebap',
              'description': 'Acılı ve doyurucu',
              'price': 120.0,
              'imageUrl': 'https://via.placeholder.com/150',
              'category': 'Kebaplar'
            },
            {
              'id': 3,
              'name': 'Ayran',
              'description': 'Bol köpüklü',
              'price': 15.0,
              'imageUrl': 'https://via.placeholder.com/150',
              'category': 'İçecekler'
            }
          ],
          statusCode: 200,
        ),
      );
    }

    if (path.contains('/addresses')) {
      if (options.method == 'POST') {
        final data = options.data;
        return handler.resolve(
          Response(
            requestOptions: options,
            data: {
              'data': {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'title': data['title'],
                'address': data['address'],
                'phone': data['phone'],
                'isDefault': data['isDefault'] ?? false,
                'createdAt': DateTime.now().toIso8601String(),
              }
            },
            statusCode: 201,
          ),
        );
      } else if (options.method == 'PUT') {
        final data = options.data;
        return handler.resolve(
          Response(
            requestOptions: options,
            data: {
              'data': {
                'id': path.split('/').last,
                'title': data['title'],
                'address': data['address'],
                'phone': data['phone'],
                'isDefault': data['isDefault'] ?? false,
                'updatedAt': DateTime.now().toIso8601String(),
              }
            },
            statusCode: 200,
          ),
        );
      }
      
      return handler.resolve(
        Response(
          requestOptions: options,
          data: [
            {
              'id': '1',
              'title': 'Ev Adresi',
              'address': 'Atatürk Mah. Cumhuriyet Cad. No:1 D:5',
              'phone': '0555 123 45 67',
              'isDefault': true
            },
            {
              'id': '2',
              'title': 'İş Adresi',
              'address': 'Organize Sanayi Bölgesi 1. Cad. No:10',
              'phone': '0555 987 65 43',
              'isDefault': false
            }
          ],
          statusCode: 200,
        ),
      );
    }

    if (path.contains(ApiConstants.orders)) {
      if (options.method == 'POST') {
        return handler.resolve(
          Response(
            requestOptions: options,
            data: {
              'id': 101,
              'status': 'pending',
              'message': 'Sipariş başarıyla oluşturuldu (MOCK)'
            },
            statusCode: 201,
          ),
        );
      } else {
        // GET orders
        return handler.resolve(
          Response(
            requestOptions: options,
            data: [
              {
                'id': 101,
                'totalAmount': 180.0,
                'status': 'pending',
                'createdAt': DateTime.now().toIso8601String(),
                'items': [
                  {
                    'productId': '2',
                    'productName': 'Adana Kebap',
                    'productCode': 'KEB001',
                    'quantity': 1,
                    'price': 120.0,
                    'totalPrice': 120.0,
                    'unit': 'Porsiyon'
                  },
                  {
                    'productId': '1',
                    'productName': 'Mercimek Çorbası',
                    'productCode': 'COR001',
                    'quantity': 1,
                    'price': 45.0,
                    'totalPrice': 45.0,
                    'unit': 'Kase'
                  },
                  {
                    'productId': '3',
                    'productName': 'Ayran',
                    'productCode': 'ICE001',
                    'quantity': 1,
                    'price': 15.0,
                    'totalPrice': 15.0,
                    'unit': 'Adet'
                  }
                ]
              }
            ],
            statusCode: 200,
          ),
        );
      }
    }
    
    // Tanımlanmamış endpointler için 404
    return handler.reject(
      DioException(
        requestOptions: options,
        error: 'Mock data not found for path: $path',
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 404,
        ),
      ),
    );
  }
}
