import 'package:data/data.dart';
import 'package:domain/domain.dart';

class LaunchRepositoryImpl extends LaunchRepository {
  final PrefsProvider _prefsProvider;

  const LaunchRepositoryImpl({required PrefsProvider prefsProvider})
      : _prefsProvider = prefsProvider;

  @override
  String getUsername() => _prefsProvider.getUsername();

  @override
  Future<void> setUsername(String username) =>
      _prefsProvider.setUsername(username);

  @override
  bool isDarkTheme() => _prefsProvider.getDarkTheme();

  @override
  Future<void> setDarkTheme(bool darkTheme) =>
      _prefsProvider.setDarkTheme(darkTheme);
}
