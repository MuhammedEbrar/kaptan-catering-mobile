import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/address_provider.dart';
import '../../widgets/empty_state_widget.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adreslerim'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AddressProvider>().loadAddresses();
            },
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (addressProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hata!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      addressProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      addressProvider.loadAddresses();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tekrar Dene'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (addressProvider.addresses.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.location_on,
              title: 'Henüz Adres Yok',
              subtitle: 'İlk adresinizi ekleyerek başlayın',
              buttonText: 'Adres Ekle',
              onButtonPressed: () {
                _showAddAddressDialog(context);
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () => addressProvider.loadAddresses(),
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addressProvider.addresses.length,
              itemBuilder: (context, index) {
                final address = addressProvider.addresses[index];
                final isDefault = address.isDefault;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isDefault
                        ? const BorderSide(color: AppColors.primary, width: 2)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                address.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (isDefault)
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          address.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              address.phone,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                _showEditAddressDialog(context, address);
                              },
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Düzenle'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                _showDeleteDialog(context, address.id!);
                              },
                              icon: const Icon(Icons.delete, size: 18),
                              label: const Text('Sil'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAddressDialog(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final titleController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    bool isDefault = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Yeni Adres Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Adres Başlığı',
                    hintText: 'İş Adresi, Ev Adresi, vb.',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Tam Adres',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: isDefault,
                  onChanged: (value) {
                    setState(() {
                      isDefault = value ?? false;
                    });
                  },
                  title: const Text('Varsayılan adres olarak ayarla'),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen tüm alanları doldurun'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                
                final navigator = Navigator.of(context);
                final scaffold = ScaffoldMessenger.of(context);

                navigator.pop(); 

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                
                final provider = context.read<AddressProvider>();
                final success = await provider.createAddress(
                      title: titleController.text,
                      address: addressController.text,
                      phone: phoneController.text,
                      isDefault: isDefault,
                    );

                
                navigator.pop();

                
                  scaffold.showSnackBar(

                    SnackBar(
                      content: Text(
                        success ? 'Adres eklendi' : 'Adres eklenemedi',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                },
              
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context, address) {
    final titleController = TextEditingController(text: address.title);
    final addressController = TextEditingController(text: address.address);
    final phoneController = TextEditingController(text: address.phone);
    bool isDefault = address.isDefault;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Adresi Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Adres Başlığı',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Tam Adres',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: isDefault,
                  onChanged: (value) {
                    setState(() {
                      isDefault = value ?? false;
                    });
                  },
                  title: const Text('Varsayılan adres olarak ayarla'),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen tüm alanları doldurun'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }


                final navigator = Navigator.of(context);
                final scaffold = ScaffoldMessenger.of(context);
                
                navigator.pop();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                final provider = context.read<AddressProvider>();
                final success = await provider.updateAddress(
                      addressId: address.id!,
                      title: titleController.text,
                      address: addressController.text,
                      phone: phoneController.text,
                      isDefault: isDefault,
                    );

                navigator.pop();

                  scaffold.showSnackBar(

                    SnackBar(
                      content: Text(
                        success ? 'Adres güncellendi' : 'Adres güncellenemedi',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Güncelle'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adresi Sil'),
        content: const Text('Bu adresi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              final success = await context.read<AddressProvider>().deleteAddress(addressId);

              if (context.mounted) {
                Navigator.pop(context);
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Adres silindi' : 'Adres silinemedi',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Sil',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}