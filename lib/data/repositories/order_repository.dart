import '../datasources/order_datasource.dart';
import '../models/order_model.dart';

class OrderRepository {
  final OrderDataSource _orderDataSource;

  OrderRepository(this._orderDataSource);

  // Sipariş oluştur
  Future<OrderModel> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String deliveryAddress,
    String? deliveryPhone,
    String? orderNote,
  }) async {
    try {
      // items'dan price ve totalPrice alanlarını çıkar
      // Backend kendi hesaplasın
      final cleanedItems = items.map((item) {
        return {
          'productId': item['productId'],
          'productName': item['productName'],
          'productCode': item['productCode'],
          'quantity': item['quantity'],
          'unit': item['unit'],
          // price ve totalPrice GÖNDERME, backend hesaplasın
        };
      }).toList();

      final orderData = {
        'userId': userId,
        'items': cleanedItems,
        'totalAmount': totalAmount,
        'deliveryAddress': deliveryAddress,
        if (deliveryPhone != null) 'deliveryPhone': deliveryPhone,
        if (orderNote != null) 'orderNote': orderNote,
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      };

      final order = await _orderDataSource.createOrder(orderData);
      print('✅ Sipariş oluşturuldu: ${order.id}');
      return order;
    } catch (e) {
      print('❌ createOrder hatası: $e');
      rethrow;
    }
  }

  // Tüm siparişleri getir
  Future<List<OrderModel>> fetchOrders() async {
    try {
      final orders = await _orderDataSource.getOrders();
      print('✅ ${orders.length} sipariş getirildi');
      return orders;
    } catch (e) {
      print('❌ fetchOrders hatası: $e');
      rethrow;
    }
  }

  // Tek sipariş getir
  Future<OrderModel> fetchOrderById(String orderId) async {
    try {
      final order = await _orderDataSource.getOrderById(orderId);
      print('✅ Sipariş getirildi: ${order.id}');
      return order;
    } catch (e) {
      print('❌ fetchOrderById hatası: $e');
      rethrow;
    }
  }

  // Duruma göre siparişleri getir
  Future<List<OrderModel>> fetchOrdersByStatus(String status) async {
    try {
      final orders = await _orderDataSource.getOrdersByStatus(status);
      print('✅ ${orders.length} sipariş getirildi (Durum: $status)');
      return orders;
    } catch (e) {
      print('❌ fetchOrdersByStatus hatası: $e');
      rethrow;
    }
  }

  // Sipariş iptal et
  Future<void> cancelOrder(String orderId) async {
    try {
      await _orderDataSource.cancelOrder(orderId);
      print('✅ Sipariş iptal edildi: $orderId');
    } catch (e) {
      print('❌ cancelOrder hatası: $e');
      rethrow;
    }
  }

  // Aktif siparişler (pending, paid, preparing, shipped)
  Future<List<OrderModel>> fetchActiveOrders() async {
    try {
      final allOrders = await fetchOrders();
      final activeOrders = allOrders.where((order) {
        return order.status == OrderModel.statusPending ||
            order.status == OrderModel.statusPaid ||
            order.status == OrderModel.statusPreparing ||
            order.status == OrderModel.statusShipped;
      }).toList();

      print('✅ ${activeOrders.length} aktif sipariş');
      return activeOrders;
    } catch (e) {
      print('❌ fetchActiveOrders hatası: $e');
      rethrow;
    }
  }

  // Tamamlanan siparişler
  Future<List<OrderModel>> fetchCompletedOrders() async {
    try {
      final allOrders = await fetchOrders();
      final completedOrders = allOrders.where((order) {
        return order.status == OrderModel.statusDelivered;
      }).toList();

      print('✅ ${completedOrders.length} tamamlanan sipariş');
      return completedOrders;
    } catch (e) {
      print('❌ fetchCompletedOrders hatası: $e');
      rethrow;
    }
  }

  // İptal edilen siparişler
  Future<List<OrderModel>> fetchCancelledOrders() async {
    try {
      final allOrders = await fetchOrders();
      final cancelledOrders = allOrders.where((order) {
        return order.status == OrderModel.statusCancelled;
      }).toList();

      print('✅ ${cancelledOrders.length} iptal edilmiş sipariş');
      return cancelledOrders;
    } catch (e) {
      print('❌ fetchCancelledOrders hatası: $e');
      rethrow;
    }
  }
}
