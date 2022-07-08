abstract class LaunchRepository {
  const LaunchRepository();

  String getUsername();

  Future<void> setUsername(String username);
}
