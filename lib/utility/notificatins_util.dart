import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

void requestNotificationPermissions(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

void configureDidReceiveLocalNotificationSubject(
  BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject,
  BuildContext context,
) {
  didReceiveLocalNotificationSubject.stream
      .listen((ReceivedNotification receivedNotification) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: receivedNotification.title != null
            ? Text(receivedNotification.title)
            : null,
        content: receivedNotification.body != null
            ? Text(receivedNotification.body)
            : null,
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              // TODO
              // Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute<void>(
              //     builder: (BuildContext context) => PmrTimesheet(),
              //   ),
              // );
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  });
}

void configureSelectNotificationSubject(
    BehaviorSubject<String> selectNotificationSubject) {
  selectNotificationSubject.stream.listen((String payload) async {
    // TODO
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(
    //       builder: (BuildContext context) => SecondScreen(payload)),
    // );
  });
}

Future<void> showSimpleNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> scheduleWeeklyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'PMR SHifts',
      'Please, do not forget to send your shift for PMR today!',
      _nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'weekly notification channel id',
            'weekly notification channel name',
            'weekly notificationdescription'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

tz.TZDateTime _nextInstanceOfMondayTenAM() {
  tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
  while (scheduledDate.weekday != DateTime.monday) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime _nextInstanceOfTenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
  tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

