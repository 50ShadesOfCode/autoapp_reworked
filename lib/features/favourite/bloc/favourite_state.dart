class FavouriteState {
  final bool isLoading;
  final List<String> data;

  FavouriteState({
    required this.isLoading,
    required this.data,
  });

  FavouriteState copyWith({
    required bool isLoading,
    required List<String> data,
  }) =>
      FavouriteState(
        isLoading: isLoading,
        data: data,
      );
}
