class CardState {
  final bool isLoading;
  final Map<String, dynamic> data;
  final bool isFavourite;
  final String url;

  CardState({
    required this.url,
    required this.isFavourite,
    required this.isLoading,
    required this.data,
  });

  CardState copyWith({
    required bool isLoading,
    required Map<String, dynamic> data,
    required bool isFavourite,
    String? url,
  }) =>
      CardState(
        url: url ?? '',
        isFavourite: isFavourite,
        isLoading: isLoading,
        data: data,
      );
}
