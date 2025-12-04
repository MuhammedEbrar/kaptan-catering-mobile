import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A), // Koyu arka plan
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 24, right: 24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sol Kolon: Logo ve Hakkında
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kaptan Food',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Profesyonel gıda tedarikçiniz. Kaliteli ürünler, uygun fiyatlar ve hızlı teslimat garantisi.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildSocialButton(
                          icon: FontAwesomeIcons.facebookF,
                          onPressed: () =>
                              _launchUrl('https://www.facebook.com/kaptanfood'),
                        ),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.instagram,
                          onPressed: () => _launchUrl(
                              'https://www.instagram.com/kaptanfoodservice/'),
                        ),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.youtube,
                          onPressed: () => _launchUrl(
                              'https://www.youtube.com/channel/UChgoYBydqsKyIyF_keERj3g'),
                        ),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.whatsapp,
                          onPressed: () =>
                              _launchUrl('https://wa.me/905554443322'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Sağ Kolon: İletişim ve Linkler
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'İletişim',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(Icons.phone, '0555 444 33 22'),
                    _buildContactItem(Icons.email, 'info@kaptanfood.com'),
                    _buildContactItem(
                        Icons.location_on, 'İkitelli OSB, İstanbul'),
                    const SizedBox(height: 24),
                    const Text(
                      'Hızlı Linkler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _buildFooterLink('Hakkımızda'),
                        _buildFooterLink('SSS'),
                        _buildFooterLink('Gizlilik Politikası'),
                        _buildFooterLink('İletişim'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Divider(color: Colors.grey[800]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2024 Kaptan Catering',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Tüm hakları saklıdır.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
