class CardState {
  final bool isLoading;
  final List<String> data;

  CardState({
    required this.isLoading,
    required this.data,
  });

  CardState copyWith({
    required bool isLoading,
    required List<String> data,
  }) =>
      CardState(
        isLoading: isLoading,
        data: data,
      );
}
