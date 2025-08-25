import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  static final _fcm = FirebaseMessaging.instance;
  static final _local = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize time zones once at app startup
    tz.initializeTimeZones();

    // Only request permission on mobile platforms, not web
    if (!kIsWeb) {
      // Import dart:io only for non-web platforms
      // ignore: avoid_web_libraries_in_flutter
      
      if (Platform.isIOS || Platform.isMacOS) {
        await _fcm.requestPermission(alert: true, badge: true, sound: true);
      }
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: ios);
    await _local.initialize(initSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null) {
        await _local.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails('fitmate_channel', 'FitMate'),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
    });
  }

  static Future<void> scheduleDailyReminder(int hour, int minute, String title, String body) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // If the scheduled time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _local.zonedSchedule(
      title.hashCode ^ minute,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails('fitmate_channel', 'FitMate'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}