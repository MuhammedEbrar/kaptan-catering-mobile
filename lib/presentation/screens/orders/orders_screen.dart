import 'package:flutter/material.dart';
import '../../widgets/custom_refresh_indicator.dart';
import '../../widgets/empty_state_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Mock sipariş verileri
  final List<Map<String, dynamic>> _orders = [
    {
      'orderNo': '#12345',
      'date': '15 Eki 2025',
      'itemCount': 2,
      'total': 530.98,
      'status': 'Hazırlanıyor',
      'statusColor': Colors.blue,
    },
    {
      'orderNo': '#12344',
      'date': '10 Eki 2025',
      'itemCount': 5,
      'total': 1250.00,
      'status': 'Teslim Edildi',
      'statusColor': Colors.green,
    },
    {
      'orderNo': '#12343',
      'date': '5 Eki 2025',
      'itemCount': 3,
      'total': 780.50,
      'status': 'Kargoda',
      'statusColor': Colors.purple,
    },
  ];

  Future<void> _refreshOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Siparişler güncellendi'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siparişlerim'),
        backgroundColor: Colors.red,
      ),
      body: _orders.isEmpty
          ? EmptyStateWidget(
              icon: Icons.receipt_long,
              title: 'Henüz Sipariş Yok',
              subtitle: 'İlk siparişinizi vererek başlayın',
              buttonText: 'Alışverişe Başla',
              onButtonPressed: () {
                Navigator.pop(context);
              },
            )
          : CustomRefreshIndicator(
              onRefresh: _refreshOrders,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(context, _orders[index]);
                },
              ),
            ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // İkon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Sipariş Bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['orderNo'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['date'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order['itemCount']} ürün',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Durum ve Fiyat
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (order['statusColor'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: order['statusColor'],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₺${order['total'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sipariş Detay Sayfası
class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sipariş ${order['orderNo']}'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Durum Badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: (order['statusColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    color: order['statusColor'],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sipariş Bilgileri
            _buildInfoCard(
              'Sipariş Bilgileri',
              [
                _buildInfoRow('Sipariş No', order['orderNo']),
                _buildInfoRow('Tarih', order['date']),
                _buildInfoRow('Ürün Sayısı', '${order['itemCount']} ürün'),
              ],
            ),

            const SizedBox(height: 16),

            // Teslimat Adresi
            _buildInfoCard(
              'Teslimat Adresi',
              [
                const Text(
                  'İş Adresi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('Mevlana Mah. Adliye Cad. No:15/A'),
                const Text('Karatay/Konya'),
                const Text('0332 123 45 67'),
              ],
            ),

            const SizedBox(height: 16),

            // Ödeme Bilgileri
            _buildInfoCard(
              'Ödeme Bilgileri',
              [
                _buildInfoRow('Ara Toplam', '₺449.98'),
                _buildInfoRow('KDV (%18)', '₺81.00'),
                const Divider(height: 24),
                _buildInfoRow(
                  'Toplam',
                  '₺${order['total'].toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tekrar Sipariş Ver Butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ürünler sepete eklendi!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tekrar Sipariş Ver',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isBold ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}