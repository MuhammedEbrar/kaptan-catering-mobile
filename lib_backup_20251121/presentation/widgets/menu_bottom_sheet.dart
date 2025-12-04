import 'package:flutter/material.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const MenuBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Menü',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.info, color: Colors.red),
            title: const Text('Hakkımızda'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              // TODO: Hakkımızda sayfasına git
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hakkımızda sayfası yakında!')),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.contact_support, color: Colors.red),
            title: const Text('İletişim'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              // TODO: İletişim sayfasına git
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('İletişim sayfası yakında!')),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
