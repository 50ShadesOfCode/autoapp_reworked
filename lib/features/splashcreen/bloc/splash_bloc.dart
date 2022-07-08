import 'dart:async';

import 'package:auto_app/features/homepage/home.dart';
import 'package:auto_app/router/router.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_event.dart';
import 'splash_state.dart';

export 'splash_event.dart';
export 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({
    required AppRouter appRouter,
    required GetUsernameUseCase getUsernameUseCase,
  })  : _appRouter = appRouter,
        _getUsernameUseCase = getUsernameUseCase,
        super(const SplashState(username: '')) {
    on<InitEvent>(_onInitEvent);
    on<AppStarted>(_onStartedEvent);
  }

  final AppRouter _appRouter;
  final GetUsernameUseCase _getUsernameUseCase;

  Future<void> _onInitEvent(InitEvent event, Emitter<SplashState> emit) async {
    final String username = _getUsernameUseCase.execute(NoParams());
    emit(state.copyWith(username: username));
  }

  Future<void> _onStartedEvent(
      AppStarted event, Emitter<SplashState> emit) async {
    _appRouter.replace(Home.page());
    emit(state);
  }
}
