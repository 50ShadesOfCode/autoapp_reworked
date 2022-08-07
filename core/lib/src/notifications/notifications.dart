import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

final NotificationService _notificationService =
    appLocator.get<NotificationService>();

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    _notificationService.flutterLocalNotificationsPlugin;

Future<void> repeatNotificationHourly() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '123',
    'Happy Wheels',
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? url = prefs.getString('noturl');
  if (url == null) return;
  await _flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    'Happy Wheels',
    await _getNotsText(url),
    RepeatInterval.hourly,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
  );
}

Future<void> repeatNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '123',
    'Happy Wheels',
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? url = prefs.getString('noturl');
  if (url == null) return;
  await _flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    'Happy Wheels',
    await _getNotsText(url),
    RepeatInterval.everyMinute,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
  );
}

Future<void> scheduleDailyFourAMNotification() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? url = prefs.getString('noturl');
  if (url == null) return;
  await _flutterLocalNotificationsPlugin.zonedSchedule(
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
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? url = prefs.getString('noturl');
  if (url == null) return;
  await _flutterLocalNotificationsPlugin.zonedSchedule(
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
  await _flutterLocalNotificationsPlugin.cancelAll();
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

//TODO: Move to bloc?
Future<String> _getNotsText(String url) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ApiProvider provider = appLocator.get<ApiProvider>();
  final String amount = await provider.getNotificationUpdates(url);
  if (amount == prefs.getString('carups')) {
    return 'Новых поступлений нет!';
  } else {
    return 'Новые поступления по вашим параметрам!';
  }
}
