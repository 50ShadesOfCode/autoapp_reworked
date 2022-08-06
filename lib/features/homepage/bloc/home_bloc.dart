import 'package:auto_app/router/router.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

export 'home_event.dart';
export 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required AppRouter appRouter,
    required IsDarkThemeUseCase isDarkThemeUseCase,
  })  : _appRouter = appRouter,
        _isDarkThemeUseCase = isDarkThemeUseCase,
        super(const HomeState(isDarktheme: false)) {
    on<InitEvent>(_onInitEvent);
  }

  final AppRouter _appRouter;
  final IsDarkThemeUseCase _isDarkThemeUseCase;

  Future<void> _onInitEvent(InitEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isDarkTheme: _isDarkThemeUseCase.execute(NoParams())));
  }
}
