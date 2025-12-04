import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _orderNotifications = true;
  bool _campaignNotifications = true;
  bool _productNotifications = false;
  String _selectedLanguage = 'Türkçe';
  String _selectedTheme = 'Açık';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        children: [
          // Bildirim Ayarları
          _buildSectionHeader('Bildirim Ayarları'),
          SwitchListTile(
            title: const Text('Sipariş Bildirimleri'),
            subtitle:
                const Text('Sipariş durumu değişikliklerinde bildirim al'),
            value: _orderNotifications,
            onChanged: (value) {
              setState(() {
                _orderNotifications = value;
              });
            },
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            title: const Text('Kampanya Bildirimleri'),
            subtitle: const Text('Kampanya ve fırsatlardan haberdar ol'),
            value: _campaignNotifications,
            onChanged: (value) {
              setState(() {
                _campaignNotifications = value;
              });
            },
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            title: const Text('Ürün Bildirimleri'),
            subtitle: const Text('Yeni ürünler ve stok güncellemeleri'),
            value: _productNotifications,
            onChanged: (value) {
              setState(() {
                _productNotifications = value;
              });
            },
            activeColor: AppColors.primary,
          ),

          const Divider(height: 32),

          // Uygulama Ayarları
          _buildSectionHeader('Uygulama Ayarları'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Dil'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Tema'),
            subtitle: Text(_selectedTheme),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showThemeDialog();
            },
          ),

          const Divider(height: 32),

          // Bilgi
          _buildSectionHeader('Bilgi'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Hakkımızda'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Gizlilik Politikası'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gizlilik politikası yakında!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Kullanım Şartları'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kullanım şartları yakında!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('İletişim'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactScreen()),
              );
            },
          ),

          const Divider(height: 32),

          // Uygulama Bilgisi
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Versiyon'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dil Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Türkçe'),
              value: 'Türkçe',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dil değiştirildi: Türkçe')),
                );
              },
              activeColor: AppColors.primary,
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language changed: English')),
                );
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tema Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Açık'),
              value: 'Açık',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tema değiştirildi: Açık')),
                );
              },
              activeColor: AppColors.primary,
            ),
            RadioListTile<String>(
              title: const Text('Koyu'),
              value: 'Koyu',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tema değiştirildi: Koyu')),
                );
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// Hakkımızda Sayfası
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkımızda'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Kaptan Catering',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'B2B Catering Çözümleri',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Misyonumuz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Kaptan Catering olarak, işletmelere kaliteli ve güvenilir catering hizmetleri sunarak, müşterilerimizin iş süreçlerini kolaylaştırmayı hedefliyoruz.',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vizyonumuz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Türkiye\'nin önde gelen B2B catering platformu olmak ve işletmelere en iyi hizmeti sunmak.',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// İletişim Sayfası
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İletişim'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.contact_support,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Bizimle İletişime Geçin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: AppColors.primary),
                title: const Text('Telefon'),
                subtitle: const Text('0332 123 45 67'),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  color: AppColors.primary,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Arama özelliği yakında!')),
                    );
                  },
                ),
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.email, color: AppColors.primary),
                title: const Text('E-posta'),
                subtitle: const Text('info@kaptancatering.com'),
                trailing: IconButton(
                  icon: const Icon(Icons.send),
                  color: AppColors.primary,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email gönderme yakında!')),
                    );
                  },
                ),
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.location_on, color: AppColors.primary),
                title: Text('Adres'),
                subtitle:
                    Text('Mevlana Mah. Adliye Cad. No:15/A\nKaratay/Konya'),
                isThreeLine: true,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Çalışma Saatleri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pazartesi - Cuma: 08:00 - 18:00\nCumartesi: 09:00 - 14:00\nPazar: Kapalı',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
