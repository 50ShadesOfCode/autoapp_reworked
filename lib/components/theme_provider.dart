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

///класс с двумя полями: светлая и темная тема, используется только для удобного доступа
class Themes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey.shade900,
    //colorScheme: const ColorScheme.dark(),
    textTheme: Typography.whiteCupertino,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue.shade900,
      highlightColor: Colors.blue.shade900,
      splashColor: Colors.blue.shade900,
      focusColor: Colors.blue.shade900,
    ),
    accentColor: Colors.blue,
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(color: Colors.blue),
    indicatorColor: Colors.blue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.blue),
      trackColor: MaterialStateProperty.all(Colors.blue.shade300),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.blue),
      ),
    ),
  );
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(color: Colors.blue),
    indicatorColor: Colors.blue,
    accentColor: Colors.blue,
    //colorScheme: const ColorScheme.light(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.blue),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.blue),
      trackColor: MaterialStateProperty.all(Colors.blue.shade300),
    ),
  );
}
