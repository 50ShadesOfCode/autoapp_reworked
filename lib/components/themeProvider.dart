import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //тема пол умолчанию
  ThemeMode themeMode = ThemeMode.light;

  //возвращает true если темная тема, false если светлая
  bool get isDarkMode => themeMode == ThemeMode.dark;
  //функция переключения темы, которая уведомляет ChangeNotifier в main.dart о том что изменилась тема, и меняет ее.
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

//класс с двумя полями: светлая и темная тема, используется только для удобного доступа
class Themes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    colorScheme: ColorScheme.light(),
  );
}
