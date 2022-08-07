import 'package:data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'car_event.dart';
import 'car_state.dart';

export 'car_event.dart';
export 'car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final ApiProvider _apiProvider;

  CarBloc({
    required ApiProvider apiProvider,
  })  : _apiProvider = apiProvider,
        super(CarState(
          isLoading: true,
          data: <String, dynamic>{},
        )) {
    on<LoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(LoadEvent event, Emitter<CarState> emit) async {
    final Map<String, dynamic> data = await _apiProvider.getCarByUrl(event.url);
    emit(state.copyWith(isLoading: false, data: data));
  }
}
