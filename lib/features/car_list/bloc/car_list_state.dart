import 'package:domain/domain.dart';

class CarListState {
  final bool isLoading;
  final List<String> data;
  final List<Car> cars;
  CarListState({
    required this.cars,
    required this.isLoading,
    required this.data,
  });

  CarListState copyWith({
    required bool isLoading,
    required List<String> data,
    required List<Car> cars,
  }) =>
      CarListState(
        cars: cars,
        isLoading: isLoading,
        data: data,
      );
}
