import 'package:flutter/material.dart';
import '../orders/orders_screen.dart';
import '../favorites/favorites_screen.dart';
import '../addresses/addresses_screen.dart';
import '../settings/settings_screen.dart';
import 'edit_profile_screen.dart';
import '../../utils/page_transitions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Kullanıcı Bilgileri Card
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.red[50],
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'İsko Tester1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Test Şirketi',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'test@firma.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menü Items
            _buildMenuItem(
              Icons.shopping_cart,
              'Siparişlerim',
              () {
                Navigator.push(
                  context,
                  FadeSlidePageRoute(page: const OrdersScreen()),
                );
              },
            ),
            _buildMenuItem(
              Icons.favorite,
              'Favorilerim',
              () {
                Navigator.push(
                  context,
                  FadeSlidePageRoute(page: const FavoritesScreen()),
                );
              },
            ),
            _buildMenuItem(
              Icons.location_on,
              'Adreslerim',
              () {
                Navigator.push(
                  context,
                  FadeSlidePageRoute(page: const AddressesScreen()),
                );
              },
            ),
            _buildMenuItem(
              Icons.settings,
              'Ayarlar',
              () {
                Navigator.push(
                  context,
                  FadeSlidePageRoute(page: const SettingsScreen()),
                );
              },
            ),
            
            const Divider(),
            
            _buildMenuItem(
              Icons.logout,
              'Çıkış Yap',
              () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Çıkış Yap'),
                    content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('İptal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Çıkış yapıldı'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Text(
                          'Çıkış Yap',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
          fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}