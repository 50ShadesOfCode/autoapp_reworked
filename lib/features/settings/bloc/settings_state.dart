class SettingsState {
  final String username;
  final bool isDarkTheme;
  final int? selectedRate;

  const SettingsState({
    required this.username,
    required this.isDarkTheme,
    required this.selectedRate,
  });

  SettingsState copyWith({
    required String username,
    required bool isDarkTheme,
    required int? selectedRate,
  }) {
    return SettingsState(
      selectedRate: selectedRate,
      username: username,
      isDarkTheme: isDarkTheme,
    );
  }
}
