import 'package:core/core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:core/core.dart';
import 'package:data/data.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) => <dynamic, dynamic>{},
    );
    tz.initializeTimeZones();
  }

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '123',
    'Happy Wheels',
  );
  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  final PrefsProvider _prefsProvider = appLocator.get<PrefsProvider>();

  Future<void> repeatNotificationHourly() async {
    final String url = _prefsProvider.getNotificationUrl();
    if (url.isEmpty) return;
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Happy Wheels',
      await _getNotsText(url),
      RepeatInterval.hourly,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> repeatNotification() async {
    final String url = _prefsProvider.getNotificationUrl();
    if (url.isEmpty) return;
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Happy Wheels',
      await _getNotsText(url),
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> scheduleDailyFourAMNotification() async {
    final String url = _prefsProvider.getNotificationUrl();
    if (url.isEmpty) return;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Happy Wheels',
      await _getNotsText(url),
      _nextInstanceOfFourAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '123',
          'Happy Wheels',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    scheduleDailyFourAMNotification();
  }

  Future<void> schedule45MinNotification() async {
    final String url = _prefsProvider.getNotificationUrl();
    if (url.isEmpty) return;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Happy Wheels',
      await _getNotsText(url),
      _nextInstanceOf45Min(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '123',
          'Happy Wheels',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    schedule45MinNotification();
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOf45Min() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(minutes: 45),
      );
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfFourAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      16,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      );
    }
    return scheduledDate;
  }

  Future<String> _getNotsText(String url) async {
    final ApiProvider provider = appLocator.get<ApiProvider>();
    final String amount = await provider.getNotificationUpdates(url);
    if (amount == _prefsProvider.getCarAmount()) {
      return 'Новых поступлений нет!';
    } else {
      return 'Новые поступления по вашим параметрам!';
    }
  }
}
