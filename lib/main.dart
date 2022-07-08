import 'dart:async';

import 'package:auto_app/application.dart';
import 'package:auto_app/utils/notification_service.dart';
import 'package:auto_app/utils/notifications.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appDI.initDependencies();
  await _configureLocalTimeZone();
  await NotificationService().init();
  await initNotifications();

  runApp(Application());
}

///Получает и настраивает время для приложения в соответствии с местным
///Используется для корректной отправки уведомлений
Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

Future<void> initNotifications() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? rate = prefs.getInt('rate');
  rate ??= 2;

  if (rate == 0) {
    cancelAllNotifications();
  } else if (rate == 1) {
    schedule45MinNotification();
  } else if (rate == 2) {
    repeatNotificationHourly();
  } else {
    scheduleDailyFourAMNotification();
  }
}
