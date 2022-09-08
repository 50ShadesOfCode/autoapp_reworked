import 'package:data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'characteristics_event.dart';
import 'characteristics_state.dart';

export 'characteristics_event.dart';
export 'characteristics_state.dart';

class CharacteristicsBloc
    extends Bloc<CharacteristicsEvent, CharacteristicsState> {
  final ApiProvider _apiProvider;

  CharacteristicsBloc({
    required ApiProvider apiProvider,
  })  : _apiProvider = apiProvider,
        super(CharacteristicsState(
          isLoading: true,
          data: <String, dynamic>{},
        )) {
    on<LoadCharsEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(
      LoadCharsEvent event, Emitter<CharacteristicsState> emit) async {
    final Map<String, dynamic> data =
        await _apiProvider.getCharsByUrl(event.url);
    emit(state.copyWith(isLoading: false, data: data));
  }
}
