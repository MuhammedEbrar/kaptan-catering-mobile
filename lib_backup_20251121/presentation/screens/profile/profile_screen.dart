import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../addresses/addresses_screen.dart';
import '../orders/orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(child: Text('Kullanıcı bilgisi yok'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Kullanıcı Bilgileri Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (user.companyName != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user.companyName!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menü Seçenekleri
              _buildMenuCard(
                context,
                icon: Icons.shopping_bag,
                title: 'Siparişlerim',
                subtitle: 'Geçmiş siparişlerinizi görüntüleyin',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrdersScreen(),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.location_on,
                title: 'Adreslerim',
                subtitle: 'Teslimat adreslerinizi yönetin',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddressesScreen(),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.person,
                title: 'Hesap Bilgilerim',
                subtitle: 'Kişisel bilgilerinizi görüntüleyin',
                onTap: () {
                  _showAccountInfo(context, user);
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.logout,
                title: 'Çıkış Yap',
                subtitle: 'Hesabınızdan çıkış yapın',
                onTap: () {
                  _showLogoutDialog(context);
                },
                isDestructive: true,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDestructive ? Colors.red : Colors.black,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showAccountInfo(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesap Bilgileri'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Ad Soyad', user.name),
              _buildInfoRow('E-posta', user.email),
              if (user.companyName != null)
                _buildInfoRow('Firma', user.companyName!),
              if (user.phone != null) _buildInfoRow('Telefon', user.phone!),
              if (user.taxNumber != null)
                _buildInfoRow('Vergi No', user.taxNumber!),
              if (user.taxOffice != null)
                _buildInfoRow('Vergi Dairesi', user.taxOffice!),
              if (user.address != null)
                _buildInfoRow('Adres', user.address!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              // 👇 CONTEXT'LERİ KAYDET
              final navigator = Navigator.of(context);
              final authProvider = context.read<AuthProvider>();

              // Dialog'u kapat
              Navigator.pop(dialogContext);

              // Logout yap
              await authProvider.logout();

              // 👇 LOGIN EKRANINA GİT, TÜM STACK'İ TEMİZLE
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false, // Tüm önceki ekranları temizle
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
  }
}