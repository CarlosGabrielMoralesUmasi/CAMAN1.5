import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
  filter: null,
  output: null,
);

class UserProvider with ChangeNotifier {
  String _userId = "";

  String get userId => _userId; 

  void setUserId(String value) {
    _userId = value;
    //logger.d(value);
    notifyListeners();
  }
} 