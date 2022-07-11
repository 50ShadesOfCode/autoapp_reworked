class HomeState {
  final bool isDarktheme;
  const HomeState({
    required this.isDarktheme,
  });

  HomeState copyWith({
    required bool isDarkTheme,
  }) {
    return HomeState(
      isDarktheme: isDarktheme,
    );
  }
}
