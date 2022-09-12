import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'car_list_event.dart';
import 'car_list_state.dart';

export 'car_list_event.dart';
export 'car_list_state.dart';

class CarListBloc extends Bloc<CarListEvent, CarListState> {
  final ApiProvider _apiProvider;

  CarListBloc({
    required ApiProvider apiProvider,
  })  : _apiProvider = apiProvider,
        super(CarListState(
          cars: <Car>[],
          isLoading: true,
          data: <String>[],
        )) {
    on<LoadListEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(
      LoadListEvent event, Emitter<CarListState> emit) async {
    final List<String> data = await _apiProvider.getCarsByParams(event.url);

    final List<Car> cars = <Car>[];
    print(data.length);
    for (int i = 0; i < data.length; i++) {
      final Map<String, dynamic> carData =
          await _apiProvider.getCardByUrl(data[i]);
      if (carData.isEmpty) continue;
      final List<String> urls = <String>[];
      for (int i = 0; i < (carData['images_urls'].length as int); i++) {
        urls.add(carData['images_urls'][i].toString());
      }
      cars.add(Car(
        isFavourite: false,
        characteristics: carData,
        images: urls,
        url: data[i],
        used: !data[i].contains('/new/'),
      ));
    }
    emit(state.copyWith(
      isLoading: false,
      data: data,
      cars: cars,
    ));
  }
}
