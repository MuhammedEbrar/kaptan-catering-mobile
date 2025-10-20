import 'package:flutter/material.dart';
import '../../data/repositories/address_repository.dart';
import '../../data/models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final AddressRepository _addressRepository;

  AddressProvider(this._addressRepository);

  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;
  bool _isLoading = false;
  String? _errorMessage;

  List<AddressModel> get addresses => _addresses;
  AddressModel? get selectedAddress => _selectedAddress;
  AddressModel? get defaultAddress => _addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => _addresses.isNotEmpty ? _addresses.first : AddressModel(userId: '', title: '', address: '', phone: ''),
      );
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAddresses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _addresses = await _addressRepository.fetchAddresses();
      
      // Varsayılan adresi seç
      if (_selectedAddress == null && _addresses.isNotEmpty) {
        _selectedAddress = defaultAddress;
      }
      
      print('✅ ${_addresses.length} adres yüklendi');
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ loadAddresses hatası: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAddress({
    required String title,
    required String address,
    required String phone,
    bool isDefault = false,
  }) async {
    try {
      final newAddress = await _addressRepository.createAddress(
        title: title,
        address: address,
        phone: phone,
        isDefault: isDefault,
      );

      _addresses.add(newAddress);
      
      if (isDefault || _addresses.length == 1) {
        _selectedAddress = newAddress;
      }

      notifyListeners();
      print('✅ Adres eklendi: ${newAddress.title}');
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ createAddress hatası: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAddress({
    required String addressId,
    required String title,
    required String address,
    required String phone,
    bool? isDefault,
  }) async {
    try {
      final updatedAddress = await _addressRepository.updateAddress(
        addressId: addressId,
        title: title,
        address: address,
        phone: phone,
        isDefault: isDefault,
      );

      final index = _addresses.indexWhere((addr) => addr.id == addressId);
      if (index >= 0) {
        _addresses[index] = updatedAddress;
      }

      notifyListeners();
      print('✅ Adres güncellendi: ${updatedAddress.title}');
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ updateAddress hatası: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId) async {
    try {
      await _addressRepository.deleteAddress(addressId);

      _addresses.removeWhere((addr) => addr.id == addressId);
      
      if (_selectedAddress?.id == addressId) {
        _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;
      }

      notifyListeners();
      print('✅ Adres silindi');
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ deleteAddress hatası: $e');
      notifyListeners();
      return false;
    }
  }

  void selectAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void reset() {
    _addresses = [];
    _selectedAddress = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}