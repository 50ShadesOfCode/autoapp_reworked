import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:http/http.dart';

final DataDI dataDI = DataDI();

class DataDI {
  Future<void> initDependencies() async {
    await initPrefs();
    await initNotifications();
    appLocator.registerSingleton<HttpAppClient>(
      HttpAppClient(
        httpClient: Client(),
      ),
    );
    appLocator.registerSingleton(
      ApiProvider(
        client: appLocator.get<HttpAppClient>(),
      ),
    );
    appLocator.registerLazySingleton<LaunchRepository>(
      () => LaunchRepositoryImpl(
        prefsProvider: appLocator.get<PrefsProvider>(),
      ),
    );

    appLocator.registerFactory<GetUsernameUseCase>(
      () => GetUsernameUseCase(
        launchRepository: appLocator.get<LaunchRepository>(),
      ),
    );
    appLocator.registerFactory<SetUsernameUseCase>(
      () => SetUsernameUseCase(
        launchRepository: appLocator.get<LaunchRepository>(),
      ),
    );
    appLocator.registerFactory<IsDarkThemeUseCase>(
      () => IsDarkThemeUseCase(
        launchRepository: appLocator.get<LaunchRepository>(),
      ),
    );
    appLocator.registerFactory<SetDarkThemeUseCase>(
      () => SetDarkThemeUseCase(
        launchRepository: appLocator.get<LaunchRepository>(),
      ),
    );
  }

  Future<void> initPrefs() async {
    final PrefsProvider prefsProvider = PrefsProvider();

    await Future.wait(
        <Future<void>>[prefsProvider.initializeSharedPreferences()]);

    appLocator.registerSingleton<PrefsProvider>(
      prefsProvider,
    );
  }

  Future<void> initNotifications() async {
    final NotificationService notificationService = NotificationService();

    await Future.wait(<Future<void>>[notificationService.init()]);

    appLocator.registerSingleton<NotificationService>(
      notificationService,
    );
  }
}
