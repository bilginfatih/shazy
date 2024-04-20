import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/network_manager.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'my_channel', // id
  'My Channel', // title
  importance: Importance.high,
);

class FirebaseNotificationManager {
  FirebaseNotificationManager._init();

  static FirebaseNotificationManager instance =
      FirebaseNotificationManager._init();

  Future<String> get notificationToken async {
    if (await NetworkManager.instance.checkNetwork()) {
      if (Platform.isIOS) {
        return await FirebaseMessaging.instance.getAPNSToken() ?? '';
      } else {
        return await FirebaseMessaging.instance.getToken() ?? '';
      }
    }
    return '';
  }

  Future<void> init() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.requestPermission();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var token = await notificationToken;
    print('FM: $token');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        if (Platform.isAndroid) {
          AndroidNotification? android = notification.android;
          if (android != null) {
            flutterLocalNotificationsPlugin.show(
              channel.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: "ic_launcher",
                  priority: Priority.max,
                  importance: Importance.max,
                  enableVibration: true,
                ),
              ),
            );
          }
        }
      }
    });
  }
}
