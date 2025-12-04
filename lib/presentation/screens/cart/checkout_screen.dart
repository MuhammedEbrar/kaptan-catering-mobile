import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/address_provider.dart'; 
import '../../../data/models/address_model.dart'; 
import '../addresses/addresses_screen.dart'; 

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  bool _termsAccepted = false;
  final TextEditingController _orderNoteController = TextEditingController();
  AddressModel? _selectedAddress; 

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final addressProvider = context.read<AddressProvider>();
    addressProvider.loadAddresses().then((_) {
      if (addressProvider.addresses.isNotEmpty) {
        final defaultAddr = addressProvider.addresses.firstWhere(
          (addr) => addr.isDefault,
          orElse: () => addressProvider.addresses.first,
        );
        setState(() {
          _selectedAddress = defaultAddr;
        });
      }
    });
  });
}

  @override
  void dispose() {
    _orderNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Özeti'),
        backgroundColor: AppColors.primary,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 1) {
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
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    _currentStep == 1 ? 'Siparişi Onayla' : 'İleri',
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
            content: _buildAddressStep(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Sipariş Özeti'),
            content: _buildSummaryStep(cartProvider),
            isActive: _currentStep >= 1,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        if (addressProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (addressProvider.addresses.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              'Kayıtlı adresiniz bulunmuyor',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddressesScreen(),
                            ),
                          ).then((_) {
                            // Adresler sayfasından dönünce yenile
                            addressProvider.loadAddresses().then((_) {
                              if (addressProvider.addresses.isNotEmpty) {
                                final defaultAddr = addressProvider.addresses.firstWhere(
                                  (addr) => addr.isDefault,
                                  orElse: () => addressProvider.addresses.first,
                                );

                                setState(() {
                                  _selectedAddress = defaultAddr;
                                });
                              }
                            });
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adres Ekle'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Teslimat adresinizi seçin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...addressProvider.addresses.map((address) {
              final isSelected = _selectedAddress?.id == address.id;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: isSelected
                      ? const BorderSide(color: AppColors.primary, width: 2)
                      : BorderSide.none,
                ),
                child: RadioListTile<String?>(
                  value: address.id,
                  groupValue: _selectedAddress?.id,
                  onChanged: (value) {
                    setState(() {
                      _selectedAddress = address;
                    });
                  },
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Varsayılan',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(address.address),
                      const SizedBox(height: 4),
                      Text(
                        address.phone,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  activeColor: AppColors.primary,
                ),
              );
            }),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddressesScreen(),
                  ),
                ).then((_) {
                  addressProvider.loadAddresses();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Yeni Adres Ekle'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
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
      },
    );
  }



  Widget _buildSummaryStep(CartProvider cartProvider) {

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
        if (_selectedAddress != null) ...[
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: AppColors.primary),
              title: Text(
                _selectedAddress!.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_selectedAddress!.address),
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

    // Adres seçildi mi kontrol et
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen teslimat adresi seçin'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();
    final authProvider = context.read<AuthProvider>();

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

    final success = await orderProvider.createOrder(
      userId: authProvider.user!.id.toString(),
      cartItems: cartProvider.items,
      totalAmount: cartProvider.getFinalTotal(),

      deliveryAddress: '${_selectedAddress!.title}\n${_selectedAddress!.address}', // 👈 SEÇİLİ ADRES
      deliveryPhone: _selectedAddress!.phone, // 👈 ADRES TELEFONU
      orderNote: _orderNoteController.text.isNotEmpty ? _orderNoteController.text : null,
    );

    if (mounted) {
      Navigator.pop(context);
    }

    if (success) {
      await cartProvider.clearCart();

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

// OrderSuccessScreen aynı kalacak...
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
                'Siparişiniz alındı. Detaylar e-posta adresinize gönderilecektir.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Ana Sayfaya Dön',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}