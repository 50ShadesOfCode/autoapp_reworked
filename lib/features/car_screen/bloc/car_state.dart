class CarState {
  final bool isLoading;
  final Map<String, dynamic> data;

  CarState({
    required this.isLoading,
    required this.data,
  });

  CarState copyWith({
    required bool isLoading,
    required Map<String, dynamic> data,
  }) =>
      CarState(
        isLoading: isLoading,
        data: data,
      );
}
