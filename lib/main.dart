import 'dart:async';

import 'package:auto_app/components/splashscreen.dart';
import 'package:auto_app/components/theme_provider.dart';
import 'package:auto_app/utils/notification_service.dart';
import 'package:auto_app/utils/notifications.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

///Получает и настраивает время для приложения в соответствии с местным
///Используется для корректной отправки уведомлений
Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

///Получает частоту уведомлений, сохраненных
Future<int?> getRate() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('rate');
}

Future<void> main() async {
  ///до того как не выполнится эта функция, другие выполняться не будут
  ///используется для корректного вызова каких-либо функций при старте приложения
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();
  await NotificationService().init();
  final int? rate = await getRate();

  ///устанавливает частоту уведомлений
  if (rate == 0) {
    cancelAllNotifications();
  } else if (rate == 1) {
    schedule45MinNotification();
  } else if (rate == 2) {
    repeatNotificationHourly();
  } else {
    scheduleDailyFourAMNotification();
  }

  ///главная функция в приложении, в которой оно само и запускается
  ///ChangeNotifier следит за какими либо изменениями, в нашем случае это изменение темы
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (BuildContext context) => ThemeProvider(),
      builder: (BuildContext context, _) {
        final ThemeProvider provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: provider.themeMode,
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          home: SplashScreen(),
        );
      },
    ),
  );
}
