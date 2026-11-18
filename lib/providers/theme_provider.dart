import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    debugPrint('ThemeProvider: ricevuto $mode');
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
  }
}
