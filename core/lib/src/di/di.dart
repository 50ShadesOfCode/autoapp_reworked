import 'package:auto_app/router/app_route_information_parser.dart';
import 'package:auto_app/router/router.dart';
import 'package:core/src/global_context.dart';
import 'package:core/src/notifications/notification_service.dart';
import 'package:get_it/get_it.dart';

final AppDI appDI = AppDI();
final GetIt appLocator = GetIt.instance;

class AppDI {
  void initDependencies() {
    initNotifications();
    final AppRouter appRouter = AppRouter();

    appLocator.registerSingleton<AppRouter>(appRouter);
    appLocator.registerSingleton<AppRouteInformationParser>(
      AppRouteInformationParser(),
    );

    appLocator.registerLazySingleton<GlobalContext>(() => GlobalContext(
        getContext: () => appRouter.navigatorKey.currentContext!));
  }

  Future<void> initNotifications() async {
    final NotificationService notificationService = NotificationService();

    await Future.wait(<Future<void>>[notificationService.init()]);

    appLocator.registerSingleton<NotificationService>(
      notificationService,
    );
  }
}
