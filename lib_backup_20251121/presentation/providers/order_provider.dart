import 'package:flutter/material.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/models/order_model.dart';
import '../../data/models/cart_item_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderProvider(this._orderRepository);

  // States
  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;
  bool _isLoading = false;
  bool _isCreatingOrder = false;
  String? _errorMessage;

  // Getters
  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  bool get isCreatingOrder => _isCreatingOrder;
  String? get errorMessage => _errorMessage;
  int get orderCount => _orders.length;

  // Sipariş oluştur
  Future<bool> createOrder({
    required String userId,
    required List<CartItem> cartItems,
    required double totalAmount,
    required String paymentMethod,
    required String deliveryAddress,
    String? deliveryPhone,
    String? orderNote,
  }) async {
    _isCreatingOrder = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // CartItem'ları OrderItem formatına çevir
      final items = cartItems.map((cartItem) {
        return {
          'productId': cartItem.product.id,
          'productName': cartItem.product.stokAdi,
          'productCode': cartItem.product.stokKodu,
          'quantity': cartItem.quantity,
          'unit': cartItem.product.birim,
          'price': cartItem.product.fiyat,
          'totalPrice': cartItem.getTotalPrice(),
        };
      }).toList();

      final order = await _orderRepository.createOrder(
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        deliveryAddress: deliveryAddress,
        deliveryPhone: deliveryPhone,
        orderNote: orderNote,
      );

      _currentOrder = order;
      _orders.insert(0, order); // En başa ekle (en yeni)
      
      print('✅ Sipariş başarıyla oluşturuldu: ${order.id}');
      
      _isCreatingOrder = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isCreatingOrder = false;
      notifyListeners();
      print('❌ createOrder hatası: $e');
      return false;
    }
  }

  // Tüm siparişleri yükle
  Future<void> loadOrders() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final orders = await _orderRepository.fetchOrders();
      _orders = orders;
      
      // Tarihe göre sırala (en yeni en başta)
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      print('✅ ${_orders.length} sipariş yüklendi');
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ loadOrders hatası: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tek sipariş yükle
  Future<void> loadOrderById(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final order = await _orderRepository.fetchOrderById(orderId);
      _currentOrder = order;
      
      // Listede güncelle (varsa)
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = order;
      }
      
      print('✅ Sipariş yüklendi: ${order.id}');
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ loadOrderById hatası: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Duruma göre siparişleri filtrele
  List<OrderModel> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Aktif siparişler
  List<OrderModel> get activeOrders {
    return _orders.where((order) {
      return order.status == OrderModel.statusPending ||
          order.status == OrderModel.statusPaid ||
          order.status == OrderModel.statusPreparing ||
          order.status == OrderModel.statusShipped;
    }).toList();
  }

  // Tamamlanan siparişler
  List<OrderModel> get completedOrders {
    return _orders.where((order) {
      return order.status == OrderModel.statusDelivered;
    }).toList();
  }

  // İptal edilen siparişler
  List<OrderModel> get cancelledOrders {
    return _orders.where((order) {
      return order.status == OrderModel.statusCancelled;
    }).toList();
  }

  // Sipariş iptal et
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _orderRepository.cancelOrder(orderId);
      
      // Local state'i güncelle
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = _orders[index].copyWith(
          status: OrderModel.statusCancelled,
          updatedAt: DateTime.now(),
        );
      }
      
      if (_currentOrder?.id == orderId) {
        _currentOrder = _currentOrder!.copyWith(
          status: OrderModel.statusCancelled,
          updatedAt: DateTime.now(),
        );
      }
      
      notifyListeners();
      print('✅ Sipariş iptal edildi: $orderId');
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      print('❌ cancelOrder hatası: $e');
      return false;
    }
  }

  // Son siparişi getir
  OrderModel? get lastOrder {
    if (_orders.isEmpty) return null;
    return _orders.first;
  }

  // Sipariş sayısı (duruma göre)
  int getOrderCountByStatus(String status) {
    return _orders.where((order) => order.status == status).length;
  }

  // Toplam sipariş tutarı
  double get totalOrderAmount {
    return _orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Reset
  void reset() {
    _orders = [];
    _currentOrder = null;
    _isLoading = false;
    _isCreatingOrder = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}