import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
  filter: null,
  output: null,
);

class AddressProvider with ChangeNotifier {
  Map<String, dynamic> _addressData = {};

  Map<String, dynamic> get addressData => _addressData;

  void setAddressData(Map<String, dynamic> value) {
    _addressData = value;
    //logger.d(value);
    notifyListeners();
  }
} 