import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderProvider(this._orderRepository);

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Siparişleri yükle
  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderRepository.fetchOrders();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sipariş oluştur
  Future<bool> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String deliveryAddress,
    String? deliveryPhone,
    String? orderNote,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final order = await _orderRepository.createOrder(
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        deliveryAddress: deliveryAddress,
        deliveryPhone: deliveryPhone,
        orderNote: orderNote,
      );

      _orders.insert(0, order); // Yeni siparişi başa ekle
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sipariş iptal et
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _orderRepository.cancelOrder(orderId);

      // Listeyi güncelle
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        // Durumu güncellemek için yeniden yükleyebiliriz veya manuel güncelleyebiliriz
        // Şimdilik yeniden yükleyelim
        await loadOrders();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
