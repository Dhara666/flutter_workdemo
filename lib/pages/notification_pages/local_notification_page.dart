import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/generated/l10n.dart';

class LocalNotification extends StatefulWidget {
  @override
  LocalNotificationState createState() => LocalNotificationState();
}

class LocalNotificationState extends State<LocalNotification> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification();
  }

  notification() async {
    print('Notification method called.!');
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var platform = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  notificationDetails() async {
    var androidNotification = AndroidNotificationDetails(
      'CHANNEL ID',
      "CHANNLE NAME",
      "channelDescription",
      enableLights: true,
      playSound: true,
    );
    var iosNotification = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformNotification =
        NotificationDetails(androidNotification, iosNotification);
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Title : ${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}',
        'Body : StackApp Infotech',
        platformNotification,
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Title : ${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}',
        'Body : StackApp Infotech',
        platformNotification,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).localNotificationAppbar),
      body: Center(
          child: commonMaterialButton(
              text: 'Send Notification',
              function: () {
                notificationDetails();
              })),
    );
  }
}
