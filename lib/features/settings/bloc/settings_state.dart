class SettingsState {
  final String username;
  final bool isDarkTheme;

  const SettingsState({
    required this.username,
    required this.isDarkTheme,
  });

  SettingsState copyWith({
    required String username,
    required bool isDarkTheme,
  }) {
    return SettingsState(
      username: username,
      isDarkTheme: isDarkTheme,
    );
  }
}
