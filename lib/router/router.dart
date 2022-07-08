import 'package:auto_app/router/page_stack_controller.dart';
import 'package:auto_app/router/router_configuration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppRouter extends RouterDelegate<RouteConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<RouteConfiguration>,
        PageStackController {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onPopPage: onPopPage,
      pages: pages,
      observers: const <NavigatorObserver>[],
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    pop();
    return true;
  }

  @override
  Future<void> setNewRoutePath(RouteConfiguration configuration) {
    resetTo(configuration.page);
    return SynchronousFuture<void>(null);
  }
}
