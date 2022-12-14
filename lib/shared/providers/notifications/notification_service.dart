import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:walkthrough/shared/providers/routes.dart';

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/walk_through_icon');

    await localNotificationsPlugin.initialize(
        const InitializationSettings(
          android: android,
        ),
        onDidReceiveNotificationResponse: (details) => _onSelectNotification(details.payload),
    );
  }


  _onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushNamed(payload);
    }
  }

  showNotification(CustomNotification notification) {
    androidDetails = const AndroidNotificationDetails(
        'lembretes_notifications_x', 'Lembretes',
        channelDescription: 'Este canal é para lembretes!',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true);

    localNotificationsPlugin.show(notification.id, notification.title,
        notification.body, NotificationDetails(android: androidDetails),
        payload: notification.payload);
  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getActiveNotifications();
    if (details != null && details.isNotEmpty) {
      _onSelectNotification(details.first.payload);
    }
  }
}
