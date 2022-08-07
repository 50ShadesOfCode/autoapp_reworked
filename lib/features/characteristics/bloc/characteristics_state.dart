class CharacteristicsState {
  final bool isLoading;
  final Map<String, dynamic> data;

  CharacteristicsState({
    required this.isLoading,
    required this.data,
  });

  CharacteristicsState copyWith({
    required bool isLoading,
    required Map<String, dynamic> data,
  }) =>
      CharacteristicsState(
        isLoading: isLoading,
        data: data,
      );
}
