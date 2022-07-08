import 'package:auto_app/router/page_with_scaffold_key.dart';
import 'package:auto_app/router/router.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/splash_bloc.dart';
import 'splashscreen_form.dart';

class SplashPage extends PageWithScaffoldKey<dynamic> {
  @override
  Route<dynamic> createRoute(BuildContext context) =>
      MaterialPageRoute<dynamic>(
        settings: this,
        builder: (BuildContext context) => BlocProvider<SplashBloc>(
          create: (_) => SplashBloc(
            appRouter: appLocator.get<AppRouter>(),
            getUsernameUseCase: appLocator.get<GetUsernameUseCase>(),
          )..add(InitEvent()),
          child: SafeArea(
            child: ScaffoldMessenger(
              key: scaffoldKey,
              child: SplashScreen(),
            ),
          ),
        ),
      );
}
