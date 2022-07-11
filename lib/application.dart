import 'package:auto_app/router/app_route_information_parser.dart';
import 'package:auto_app/router/router.dart';
import 'package:auto_app/router/router_configuration.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late final AppRouter appRouter;
  late final RouteInformationParser<RouteConfiguration> routeInformationParser;

  late bool isDarkTheme;

  @override
  Future<void> initState() async {
    appRouter = appLocator.get<AppRouter>();
    routeInformationParser = appLocator.get<AppRouteInformationParser>();
    await _configureTheme();
    super.initState();
  }

  Future<void> _configureTheme() async {
    final bool value = appLocator.get<PrefsProvider>().getDarkTheme();
    final ThemeProvider provider =
        Provider.of<ThemeProvider>(context, listen: false);
    provider.toggleTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (BuildContext context) => ThemeProvider(),
      builder: (BuildContext context, _) {
        final ThemeProvider provider = Provider.of<ThemeProvider>(context);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Happy Wheels',
          themeMode: provider.themeMode,
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          routerDelegate: appRouter,
          routeInformationParser: routeInformationParser,
        );
      },
    );
  }
}
