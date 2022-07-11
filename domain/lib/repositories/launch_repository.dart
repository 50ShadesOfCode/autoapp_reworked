abstract class LaunchRepository {
  const LaunchRepository();

  String getUsername();

  Future<void> setUsername(String username);

  Future<void> setDarkTheme(bool darkTheme);

  bool isDarkTheme();
}
