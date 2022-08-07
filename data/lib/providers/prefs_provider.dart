import 'package:shared_preferences/shared_preferences.dart';

class PrefsProvider {
  late SharedPreferences _sharedPreferences;

  static const String _keyUsername = 'username';
  static const String _keyDarkTheme = 'darkTheme';
  static const String _keyNotificationsUrl = 'notificationsUrl';
  static const String _keyCarAmount = 'carAmount';
  static const String _keyNotificationsRate = 'notificationsRate';

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

  String getNotificationUrl() {
    final String? notificationsUrl =
        _sharedPreferences.getString(_keyNotificationsUrl);
    return notificationsUrl ?? '';
  }

  Future<void> setNotificationsUrl(String notificationsUrl) async {
    await _sharedPreferences.setString(_keyNotificationsUrl, notificationsUrl);
  }

  Future<void> setCarAmount(String carAmount) async {
    await _sharedPreferences.setString(_keyCarAmount, carAmount);
  }

  String getCarAmount() {
    final String? carAmount = _sharedPreferences.getString(_keyCarAmount);
    return carAmount ?? '';
  }

  int getNotificationRate() {
    return _sharedPreferences.getInt(_keyNotificationsRate) ?? 0;
  }

  Future<void> setNotificationsRate(int rate) async {
    await _sharedPreferences.setInt(_keyNotificationsRate, rate);
  }
}
