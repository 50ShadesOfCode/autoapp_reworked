class CardState {
  final bool isLoading;
  final Map<String, dynamic> data;

  CardState({
    required this.isLoading,
    required this.data,
  });

  CardState copyWith({
    required bool isLoading,
    required Map<String, dynamic> data,
  }) =>
      CardState(
        isLoading: isLoading,
        data: data,
      );
}
