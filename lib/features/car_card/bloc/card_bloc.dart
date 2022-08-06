import 'package:data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'card_event.dart';
import 'card_state.dart';

export 'card_event.dart';
export 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final ApiProvider _apiProvider;

  CardBloc({
    required ApiProvider apiProvider,
  })  : _apiProvider = apiProvider,
        super(CardState(
          isLoading: true,
          data: <String, dynamic>{},
        )) {
    on<LoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(LoadEvent event, Emitter<CardState> emit) async {
    final Map<String, dynamic> data =
        await _apiProvider.getCardByUrl(event.url);
    emit(state.copyWith(isLoading: false, data: data));
  }
}
