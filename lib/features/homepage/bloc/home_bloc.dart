import 'package:auto_app/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

export 'home_event.dart';
export 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required AppRouter appRouter,
  })  : _appRouter = appRouter,
        super(const HomeState());

  final AppRouter _appRouter;
}
