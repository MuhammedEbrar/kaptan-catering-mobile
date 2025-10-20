import '../datasources/address_datasource.dart';
import '../models/address_model.dart';

class AddressRepository {
  final AddressDataSource _addressDataSource;

  AddressRepository(this._addressDataSource);

  Future<List<AddressModel>> fetchAddresses() async {
    try {
      return await _addressDataSource.getAddresses();
    } catch (e) {
      print('❌ fetchAddresses hatası: $e');
      rethrow;
    }
  }

  Future<AddressModel> createAddress({
    required String title,
    required String address,
    required String phone,
    bool isDefault = false,
  }) async {
    try {
      final addressData = {
        'title': title,
        'address': address,
        'phone': phone,
        'isDefault': isDefault,
      };

      return await _addressDataSource.createAddress(addressData);
    } catch (e) {
      print('❌ createAddress hatası: $e');
      rethrow;
    }
  }

  Future<AddressModel> updateAddress({
    required String addressId,
    required String title,
    required String address,
    required String phone,
    bool? isDefault,
  }) async {
    try {
      final addressData = {
        'title': title,
        'address': address,
        'phone': phone,
        if (isDefault != null) 'isDefault': isDefault,
      };

      return await _addressDataSource.updateAddress(addressId, addressData);
    } catch (e) {
      print('❌ updateAddress hatası: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _addressDataSource.deleteAddress(addressId);
    } catch (e) {
      print('❌ deleteAddress hatası: $e');
      rethrow;
    }
  }
}