import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages dark/light theme switching with persistence.
class ThemeProvider extends ChangeNotifier {
  static const _key = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _load();
  }

  void toggle() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _themeMode.name);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_key);
    if (val == 'light') _themeMode = ThemeMode.light;
    notifyListeners();
  }
}
