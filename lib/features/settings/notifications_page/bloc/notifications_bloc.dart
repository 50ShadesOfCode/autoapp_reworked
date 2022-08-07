import 'package:data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifications_event.dart';
import 'notifications_state.dart';

export 'notifications_event.dart';
export 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final ApiProvider _apiProvider;
  final PrefsProvider _prefsProvider;

  NotificationsBloc({
    required ApiProvider apiProvider,
    required PrefsProvider prefsProvider,
  })  : _apiProvider = apiProvider,
        _prefsProvider = prefsProvider,
        super(NotificationsState()) {
    on<SaveEvent>(_onSaveEvent);
  }

  Future<void> _onSaveEvent(
      SaveEvent event, Emitter<NotificationsState> emit) async {
    _prefsProvider.setNotificationsUrl(event.url);
    final String carAmount =
        await _apiProvider.getNotificationUpdates(event.url);
    _prefsProvider.setCarAmount(carAmount);
    emit(state);
  }
}
