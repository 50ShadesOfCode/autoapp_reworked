import 'package:flutter/material.dart';

///класс с двумя полями: светлая и темная тема, используется только для удобного доступа
class Themes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: const ColorScheme.dark(),
    textTheme: Typography.whiteCupertino,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue.shade900,
      highlightColor: Colors.blue.shade900,
      splashColor: Colors.blue.shade900,
      focusColor: Colors.blue.shade900,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue.shade900)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.blue),
      trackColor: MaterialStateProperty.all(Colors.blue.shade300),
    ),
  );
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    colorScheme: const ColorScheme.light(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue.shade900)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.blue),
      trackColor: MaterialStateProperty.all(Colors.blue.shade300),
    ),
  );
}
