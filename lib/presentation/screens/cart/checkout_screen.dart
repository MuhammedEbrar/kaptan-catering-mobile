import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}



class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  int _selectedPaymentIndex = 0; // 0: Kredi Kartı, 1: Kapıda Ödeme
  bool _termsAccepted = false;
  final TextEditingController _orderNoteController = TextEditingController();

  @override
  void dispose() {
    _orderNoteController.dispose();
    super.dispose();
  }

    @override
    void initState() {
    super.initState();
      // User bilgisini yenile
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthProvider>().checkLoginStatus();
  });
}

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Özeti'),
        backgroundColor: AppColors.primary,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep++;
            });
          } else {
            _completeOrder(context);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    _currentStep == 2 ? 'Siparişi Onayla' : 'İleri',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Geri'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Teslimat Adresi'),
            content: _buildAddressStep(authProvider),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Ödeme Yöntemi'),
            content: _buildPaymentStep(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Sipariş Özeti'),
            content: _buildSummaryStep(cartProvider, authProvider),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

Widget _buildAddressStep(AuthProvider authProvider) {
  final user = authProvider.user;
  
  // Debug için print ekle
  print('🔍 User address: ${user?.address}');
  print('🔍 User phone: ${user?.phone}');
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Teslimat Adresi',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 16),
      
      // Adres var mı kontrol et
      if (user != null && user.address != null && user.address!.trim().isNotEmpty) ...[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user.companyName ?? 'Firma Adresi',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  user.address!,
                  style: const TextStyle(height: 1.5),
                ),
                if (user.phone != null && user.phone!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        user.phone!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ] else ...[
        Card(
          color: Colors.orange[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Profil ayarlarınızdan adres bilgisi ekleyiniz.',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // Profile sayfasına git
                    Navigator.popUntil(context, (route) => route.isFirst);
                    // TODO: Profil tab'ına geç
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Profile Git'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      
      // ... Sipariş notu kısmı aynı kalacak
        
        // Sipariş Notu
        TextField(
          controller: _orderNoteController,
          decoration: const InputDecoration(
            labelText: 'Sipariş Notu (Opsiyonel)',
            hintText: 'Özel talepleriniz varsa buraya yazın...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.note),
          ),
          maxLines: 3,
          maxLength: 500,
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ödeme yönteminizi seçin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Card(
          child: RadioListTile<int>(
            value: 0,
            groupValue: _selectedPaymentIndex,
            onChanged: (value) {
              setState(() {
                _selectedPaymentIndex = value!;
              });
            },
            title: const Text('Kredi/Banka Kartı'),
            subtitle: const Text('İyzico güvenli ödeme'),
            secondary: Icon(Icons.credit_card, color: AppColors.primary),
            activeColor: AppColors.primary,
          ),
        ),
        Card(
          child: RadioListTile<int>(
            value: 1,
            groupValue: _selectedPaymentIndex,
            onChanged: (value) {
              setState(() {
                _selectedPaymentIndex = value!;
              });
            },
            title: const Text('Kapıda Ödeme'),
            subtitle: const Text('Teslimat sırasında nakit veya POS ile'),
            secondary: Icon(Icons.money, color: AppColors.primary),
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep(CartProvider cartProvider, AuthProvider authProvider) {
    final paymentMethod = _selectedPaymentIndex == 0 ? 'Kredi/Banka Kartı' : 'Kapıda Ödeme';
    final user = authProvider.user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sipariş Bilgileri',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        
        // Ürünler
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ürünler',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...cartProvider.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${item.product.stokAdi} x${item.quantity}',
                    style: const TextStyle(fontSize: 14),
                  ),
                )),
              ],
            ),
          ),
        ),
        
        // Teslimat Adresi
        if (user?.address != null) ...[
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: AppColors.primary),
              title: Text(
                user!.companyName ?? 'Teslimat Adresi',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.address!),
              trailing: TextButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 0;
                  });
                },
                child: const Text('Değiştir'),
              ),
            ),
          ),
        ],
        
        // Ödeme Yöntemi
        Card(
          child: ListTile(
            leading: Icon(
              _selectedPaymentIndex == 0 ? Icons.credit_card : Icons.money,
              color: AppColors.primary,
            ),
            title: const Text(
              'Ödeme Yöntemi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(paymentMethod),
            trailing: TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = 1;
                });
              },
              child: const Text('Değiştir'),
            ),
          ),
        ),
        
        // Sipariş Notu
        if (_orderNoteController.text.isNotEmpty) ...[
          Card(
            child: ListTile(
              leading: Icon(Icons.note, color: AppColors.primary),
              title: const Text(
                'Sipariş Notu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_orderNoteController.text),
            ),
          ),
        ],
        
        // Tutar Özeti
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPriceRow('Ara Toplam', cartProvider.getSubtotal()),
                _buildPriceRow('KDV', cartProvider.getKdvAmount()),
                _buildPriceRow('Kargo', cartProvider.getShippingCost()),
                const Divider(height: 24),
                _buildPriceRow('Toplam', cartProvider.getFinalTotal(), isBold: true),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Kullanım Şartları
        CheckboxListTile(
          value: _termsAccepted,
          onChanged: (value) {
            setState(() {
              _termsAccepted = value!;
            });
          },
          title: const Text('Kullanım koşullarını kabul ediyorum'),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double price, {bool isBold = false}) {
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
            '₺${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isBold ? AppColors.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeOrder(BuildContext context) async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen kullanım koşullarını kabul edin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();
    final authProvider = context.read<AuthProvider>();

    // Validasyon
    final errors = cartProvider.validateCart();
    if (errors.isNotEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errors.join('\n')),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Kullanıcı kontrolü
    if (authProvider.user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kullanıcı bilgisi bulunamadı'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Adres kontrolü
    if (authProvider.user!.address == null || authProvider.user!.address!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen profil ayarlarınızdan adres bilgisi ekleyin'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Loading dialog göster
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sipariş oluşturuluyor...'),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Sipariş oluştur
    final success = await orderProvider.createOrder(
      userId: authProvider.user!.id.toString(),
      cartItems: cartProvider.items,
      totalAmount: cartProvider.getFinalTotal(),
      paymentMethod: _selectedPaymentIndex == 0 ? 'iyzico' : 'cash_on_delivery',
      deliveryAddress: authProvider.user!.address!,
      deliveryPhone: authProvider.user!.phone,
      orderNote: _orderNoteController.text.isNotEmpty ? _orderNoteController.text : null,
    );

    // Dialog'u kapat
    if (mounted) {
      Navigator.pop(context);
    }

    if (success) {
      // ✅ SEPET TEMİZLE
      await cartProvider.clearCart();

      // Başarı sayfasına git
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(
              orderId: orderProvider.currentOrder!.id!,
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(orderProvider.errorMessage ?? 'Sipariş oluşturulamadı'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

// Sipariş Başarılı Sayfası
class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                'Siparişiniz Alındı!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Sipariş No: #$orderId',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Siparişiniz hazırlanıyor',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Ana sayfaya dön (tüm navigation stack'i temizle)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Ana Sayfaya Dön',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}