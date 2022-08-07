import 'package:auto_app/router/router.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_event.dart';
import 'settings_state.dart';

export 'settings_event.dart';
export 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppRouter _appRouter;
  final PrefsProvider _prefsProvider;
  final NotificationService _notificationService;
  final IsDarkThemeUseCase _isDarkThemeUseCase;
  final SetDarkThemeUseCase _setDarkThemeUseCase;
  final GetUsernameUseCase _getUsernameUseCase;
  final SetUsernameUseCase _setUsernameUseCase;

  SettingsBloc({
    required NotificationService notificationService,
    required IsDarkThemeUseCase isDarkThemeUseCase,
    required AppRouter appRouter,
    required SetDarkThemeUseCase setDarkThemeUseCase,
    required GetUsernameUseCase getUsernameUseCase,
    required SetUsernameUseCase setUsernameUseCase,
    required PrefsProvider prefsProvider,
  })  : _appRouter = appRouter,
        _isDarkThemeUseCase = isDarkThemeUseCase,
        _setDarkThemeUseCase = setDarkThemeUseCase,
        _getUsernameUseCase = getUsernameUseCase,
        _setUsernameUseCase = setUsernameUseCase,
        _prefsProvider = prefsProvider,
        _notificationService = notificationService,
        super(const SettingsState(
          username: '',
          isDarkTheme: false,
          selectedRate: 0,
        )) {
    on<InitSettingsEvent>(_onInitEvent);
    on<SwitchThemeEvent>(_onSwitchThemeEvent);
    on<SetUsernameEvent>(_onSetUsernameEvent);
    on<SelectRateEvent>(_onSelectRateEvent);
  }
  Future<void> _onInitEvent(
      InitSettingsEvent event, Emitter<SettingsState> emit) async {
    final String username = _getUsernameUseCase.execute(NoParams());
    final bool isDark = _isDarkThemeUseCase.execute(NoParams());
    emit(state.copyWith(
      username: username,
      isDarkTheme: isDark,
      selectedRate: state.selectedRate,
    ));
  }

  Future<void> _onSwitchThemeEvent(
      SwitchThemeEvent event, Emitter<SettingsState> emit) async {
    _setDarkThemeUseCase.execute(!state.isDarkTheme);
    emit(state.copyWith(
      username: state.username,
      isDarkTheme: !state.isDarkTheme,
      selectedRate: state.selectedRate,
    ));
  }

  Future<void> _onSetUsernameEvent(
      SetUsernameEvent event, Emitter<SettingsState> emit) async {
    _setUsernameUseCase.execute(event.username);
    emit(state.copyWith(
      username: event.username,
      isDarkTheme: state.isDarkTheme,
      selectedRate: state.selectedRate,
    ));
  }

  Future<void> _onSelectRateEvent(
      SelectRateEvent event, Emitter<SettingsState> emit) async {
    if (event.selectedRate == null) return;
    _prefsProvider.setNotificationsRate(event.selectedRate!);
    _notificationService.cancelAllNotifications();
    if (event.selectedRate == 1) {
      _notificationService.schedule45MinNotification();
    }
    if (event.selectedRate == 2) {
      _notificationService.repeatNotificationHourly();
    }
    if (event.selectedRate == 3) {
      _notificationService.scheduleDailyFourAMNotification();
    }
    emit(state.copyWith(
      username: state.username,
      isDarkTheme: state.isDarkTheme,
      selectedRate: event.selectedRate,
    ));
  }
}
