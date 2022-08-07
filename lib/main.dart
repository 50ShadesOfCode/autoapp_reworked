import 'package:auto_app/application.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appDI.initDependencies();
  await dataDI.initDependencies();

  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? rate = prefs.getInt('rate');
  rate ??= 2;

  if (rate == 0) {
    appLocator.get<NotificationService>().cancelAllNotifications();
  } else if (rate == 1) {
    appLocator.get<NotificationService>().schedule45MinNotification();
  } else if (rate == 2) {
    appLocator.get<NotificationService>().repeatNotificationHourly();
  } else {
    appLocator.get<NotificationService>().scheduleDailyFourAMNotification();
  }

  runApp(Application());
}
