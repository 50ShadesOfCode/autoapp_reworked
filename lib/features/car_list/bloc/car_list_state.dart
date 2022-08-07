class CarListState {
  final bool isLoading;
  final List<String> data;

  CarListState({
    required this.isLoading,
    required this.data,
  });

  CarListState copyWith({
    required bool isLoading,
    required List<String> data,
  }) =>
      CarListState(
        isLoading: isLoading,
        data: data,
      );
}
