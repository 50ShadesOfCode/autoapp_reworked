import 'package:domain/domain.dart';

class FavouriteState {
  final bool isLoading;
  final List<String> data;
  final List<Car> cars;

  FavouriteState({
    required this.isLoading,
    required this.data,
    required this.cars,
  });

  FavouriteState copyWith({
    required bool isLoading,
    required List<String> data,
    required List<Car> cars,
  }) =>
      FavouriteState(
        cars: cars,
        isLoading: isLoading,
        data: data,
      );
}
