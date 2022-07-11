import 'package:shared_preferences/shared_preferences.dart';

class PrefsProvider {
  late SharedPreferences _sharedPreferences;

  static const String _keyUsername = 'username';
  static const String _keyDarkTheme = 'darkTheme';

  Future<void> initializeSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setUsername(String username) async {
    await _sharedPreferences.setString(_keyUsername, username);
  }

  String getUsername() {
    final String? username = _sharedPreferences.getString(_keyUsername);
    return username ?? '';
  }

  Future<void> setDarkTheme(bool darkTheme) async {
    await _sharedPreferences.setBool(_keyDarkTheme, darkTheme);
  }

  bool getDarkTheme() {
    final bool? darkTheme = _sharedPreferences.getBool(_keyDarkTheme);
    return darkTheme ?? false;
  }
}
