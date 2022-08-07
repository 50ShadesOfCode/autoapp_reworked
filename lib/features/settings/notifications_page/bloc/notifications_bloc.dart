import 'package:data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifications_event.dart';
import 'notifications_state.dart';

export 'notifications_event.dart';
export 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final ApiProvider _apiProvider;

  NotificationsBloc({
    required ApiProvider apiProvider,
  })  : _apiProvider = apiProvider,
        super(NotificationsState()) {
    on<SaveEvent>(_onSaveEvent);
  }

  Future<void> _onSaveEvent(
      SaveEvent event, Emitter<NotificationsState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('noturl', event.url);
    final String carups = await _apiProvider.getNotificationUpdates(event.url);
    prefs.setString('carups', carups);
    emit(state);
  }
}
