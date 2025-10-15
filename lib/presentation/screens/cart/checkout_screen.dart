import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  int _selectedAddressIndex = 0;
  int _selectedPaymentIndex = 0;
  bool _termsAccepted = false;

  final List<Map<String, String>> _addresses = [
    {
      'title': 'İş Adresi',
      'address': 'Mevlana Mah. Adliye Cad. No:15/A Karatay/Konya',
      'phone': '0332 123 45 67',
    },
    {
      'title': 'Depo Adresi',
      'address': 'Organize Sanayi Bölgesi 5. Cad. No:22 Selçuklu/Konya',
      'phone': '0332 987 65 43',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Özeti'),
        backgroundColor: Colors.red,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep++;
            });
          } else {
            _completeOrder();
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
                    backgroundColor: Colors.red,
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
            content: _buildAddressStep(),
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
            content: _buildSummaryStep(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Teslimat adresinizi seçin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        ...List.generate(_addresses.length, (index) {
          final address = _addresses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: RadioListTile<int>(
              value: index,
              groupValue: _selectedAddressIndex,
              onChanged: (value) {
                setState(() {
                  _selectedAddressIndex = value!;
                });
              },
              title: Text(
                address['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(address['address']!),
                  const SizedBox(height: 4),
                  Text(
                    address['phone']!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              activeColor: Colors.red,
            ),
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Yeni adres ekleme yakında!')),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Yeni Adres Ekle'),
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
            secondary: const Icon(Icons.credit_card, color: Colors.red),
            activeColor: Colors.red,
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
            secondary: const Icon(Icons.money, color: Colors.red),
            activeColor: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    final selectedAddress = _addresses[_selectedAddressIndex];
    final paymentMethod = _selectedPaymentIndex == 0 
        ? 'Kredi/Banka Kartı' 
        : 'Kapıda Ödeme';

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
                const Text('2 ürün'),
                const Text('170 CC TEKSÖT YARIM YAĞLI AYRAN x2'),
                const Text('2000GR ÇOBANYILDIZI KAŞAR PEYNİRİ x1'),
              ],
            ),
          ),
        ),
        
        // Teslimat Adresi
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: Text(
              selectedAddress['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(selectedAddress['address']!),
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
        
        // Ödeme Yöntemi
        Card(
          child: ListTile(
            leading: Icon(
              _selectedPaymentIndex == 0 ? Icons.credit_card : Icons.money,
              color: Colors.red,
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
        
        // Tutar Özeti
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPriceRow('Ara Toplam', '₺449.98'),
                _buildPriceRow('KDV (%18)', '₺81.00'),
                const Divider(height: 24),
                _buildPriceRow('Toplam', '₺530.98', isBold: true),
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
          activeColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isBold = false}) {
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
            price,
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

  void _completeOrder() {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen kullanım koşullarını kabul edin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Sipariş başarılı sayfasına git
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderSuccessScreen(),
      ),
    );
  }
}

// Basit sipariş başarılı sayfası
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

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
                child: const Text(
                  'Sipariş No: #12345',
                  style: TextStyle(
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
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