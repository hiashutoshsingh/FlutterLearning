import 'package:flutter/material.dart';

class DarkMode extends ChangeNotifier {
  static DarkMode instance = DarkMode();
  bool isDarkMode = false;
  changeTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
