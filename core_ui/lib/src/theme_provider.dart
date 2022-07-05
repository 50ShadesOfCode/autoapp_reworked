import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //тема по умолчанию
  ThemeMode themeMode = ThemeMode.light;

  //возвращает true если темная тема, false если светлая
  bool get isDarkMode => themeMode == ThemeMode.dark;
  //функция переключения темы, которая уведомляет ChangeNotifier в main.dart о том что изменилась тема, и меняет ее.
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
