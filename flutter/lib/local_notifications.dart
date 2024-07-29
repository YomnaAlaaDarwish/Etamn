import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // Map to store periodic notifications for each user
  static final Map<String, List<Map<String, dynamic>>> userPeriodicNotifications = {};

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          onDidReceiveLocalNotification: (id, title, body, payload) => null,
        );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static Future<void> showPeriodicNotification({
    required String userId,
    required String title,
    required String body,
    required String payload,
    required String medicineName,
    required String medicineDose,
    required int frequency,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Initialize list if it doesn't exist for the user
    userPeriodicNotifications.putIfAbsent(userId, () => []);

    // Check if the medicine name already exists
    bool foundExisting = false;
    int existingIndex = -1;
    for (int i = 0; i < userPeriodicNotifications[userId]!.length; i++) {
      if (userPeriodicNotifications[userId]![i]['medicineName'] == medicineName) {
        foundExisting = true;
        existingIndex = i;
        break;
      }
    }

    int notificationId;

    if (foundExisting) {
      // Update existing notification
      userPeriodicNotifications[userId]![existingIndex] = {
        'title': title,
        'body': body,
        'payload': payload,
        'medicineName': medicineName,
        'medicineDose': medicineDose,
        'notificationId': existingIndex,
      };

      notificationId = existingIndex;
    } else {
      // Add new notification
      userPeriodicNotifications[userId]!.add({
        'title': title,
        'body': body,
        'payload': payload,
        'medicineName': medicineName,
        'medicineDose': medicineDose,
        'notificationId': userPeriodicNotifications[userId]!.length,
      });

      notificationId = userPeriodicNotifications[userId]!.length - 1;
    }

    // Schedule or update the notification using the plugin
    await _flutterLocalNotificationsPlugin.cancel(notificationId); // Cancel old notification
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      notificationId,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      payload: payload,
    );
  }

 static Future<void> cancelSpecificNotification(String userId, int notificationId) async {
  if (userPeriodicNotifications.containsKey(userId)) {
    final notificationIndex = userPeriodicNotifications[userId]!.indexWhere(
        (notification) => notification['notificationId'] == notificationId);

    if (notificationIndex != -1) {
      // Cancel the notification
      await _flutterLocalNotificationsPlugin.cancel(notificationId);

      // Remove the notification using the specific ID
      userPeriodicNotifications[userId]!
          .removeWhere((notification) => notification['notificationId'] == notificationId);
    }
  }
}


  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    userPeriodicNotifications.clear(); // Clear all user-specific notifications
  }
}
