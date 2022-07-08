class SplashState {
  final String username;
  const SplashState({required this.username});

  SplashState copyWith({
    required String username,
  }) {
    return SplashState(
      username: username,
    );
  }
}
