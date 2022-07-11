import 'package:auto_app/features/homepage/home_form.dart';
import 'package:auto_app/router/page_with_scaffold_key.dart';
import 'package:auto_app/router/router.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';

class HomePage extends PageWithScaffoldKey<dynamic> {
  @override
  Route<dynamic> createRoute(BuildContext context) =>
      MaterialPageRoute<dynamic>(
        settings: this,
        builder: (BuildContext context) => BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            appRouter: appLocator.get<AppRouter>(),
            isDarkThemeUseCase: appLocator.get<IsDarkThemeUseCase>(),
          ),
          child: SafeArea(
            child: ScaffoldMessenger(
              key: scaffoldKey,
              child: HomeScreen(),
            ),
          ),
        ),
      );
}
