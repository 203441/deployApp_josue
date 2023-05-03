import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  // ignore: prefer_const_declarations
  final InitializationSettings initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid, iOS: null, macOS: null);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotifications() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails();

  await flutterLocalNotificationsPlugin.show(
      0,
      'Se agregó una nota',
      'Tienes una nueva nota en tu lista de notas',
      const NotificationDetails(
          android: androidNotificationDetails,
          iOS: null,
          macOS: darwinNotificationDetails));
}
