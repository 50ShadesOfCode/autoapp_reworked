import 'package:data/data.dart';
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
          isLoading: true,
          data: <String>[],
        )) {
    on<LoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(LoadEvent event, Emitter<CarListState> emit) async {
    final List<String> data = await _apiProvider.getCarsByParams(event.url);
    emit(state.copyWith(isLoading: false, data: data));
  }
}
