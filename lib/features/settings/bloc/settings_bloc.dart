import 'package:auto_app/router/router.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_event.dart';
import 'settings_state.dart';

export 'settings_event.dart';
export 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppRouter _appRouter;
  final IsDarkThemeUseCase _isDarkThemeUseCase;
  final SetDarkThemeUseCase _setDarkThemeUseCase;
  final GetUsernameUseCase _getUsernameUseCase;
  final SetUsernameUseCase _setUsernameUseCase;

  SettingsBloc({
    required IsDarkThemeUseCase isDarkThemeUseCase,
    required AppRouter appRouter,
    required SetDarkThemeUseCase setDarkThemeUseCase,
    required GetUsernameUseCase getUsernameUseCase,
    required SetUsernameUseCase setUsernameUseCase,
  })  : _appRouter = appRouter,
        _isDarkThemeUseCase = isDarkThemeUseCase,
        _setDarkThemeUseCase = setDarkThemeUseCase,
        _getUsernameUseCase = getUsernameUseCase,
        _setUsernameUseCase = setUsernameUseCase,
        super(const SettingsState(username: '', isDarkTheme: false)) {
    on<InitEvent>(_onInitEvent);
    on<SwitchThemeEvent>(_onSwitchThemeEvent);
  }
  Future<void> _onInitEvent(
      InitEvent event, Emitter<SettingsState> emit) async {
    final String username = _getUsernameUseCase.execute(NoParams());
    final bool isDark = _isDarkThemeUseCase.execute(NoParams());
    emit(state.copyWith(
      username: username,
      isDarkTheme: isDark,
    ));
  }

  Future<void> _onSwitchThemeEvent(
      SwitchThemeEvent event, Emitter<SettingsState> emit) async {
    _setDarkThemeUseCase.execute(!state.isDarkTheme);
    emit(state.copyWith(
      username: state.username,
      isDarkTheme: !state.isDarkTheme,
    ));
  }
}
