import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

///плагин для получения доступа к уведомлениям
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

///функция для повторения уведомлений каждый час
Future<void> repeatNotificationHourly() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '123',
    'Auto App',
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? url = prefs.getString('noturl');
  if (url == null) return;
  await flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    'Auto App',
    await _getNotsText(url),
    RepeatInterval.hourly,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
  );
}

///функция для повторения уведомлений ежеминутно, использовалась только для их проверки
Future<void> repeatNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '123',
    'Auto App',
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? url = prefs.getString('noturl');
  if (url == null) return;
  await flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    'Auto App',
    await _getNotsText(url),
    RepeatInterval.everyMinute,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
  );
}

///планирует уведомление на 16.00 следующего дня
Future<void> scheduleDailyFourAMNotification() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? url = prefs.getString('noturl');
  if (url == null) return;
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Auto App',
    await _getNotsText(url),
    _nextInstanceOfFourAM(),
    const NotificationDetails(
      android: AndroidNotificationDetails('123', 'Auto App'),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
  scheduleDailyFourAMNotification();
}

///планирует уведомления каждые 45 минут
Future<void> schedule45MinNotification() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? url = prefs.getString('noturl');
  if (url == null) return;
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Auto App',
    await _getNotsText(url),
    _nextInstanceOf45Min(),
    const NotificationDetails(
      android: AndroidNotificationDetails('123', 'Auto App'),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
  schedule45MinNotification();
}

///выключает все уведомления
Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

///получаем следующие 45 минут просто добавляя к времени последнего уведомления 45 минут
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

///получаем следующие 16.00 просто добавляя к 16.00 сегодняшнего дня 1 день
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

///получает количество автомобилей по заданным характеристикам с сервера, сравнивает с сохраненным и в зависимости от сравнения выдает текст уведомления
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
