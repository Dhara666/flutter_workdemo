import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/notification_pages/firebase_notification_page.dart';
import 'package:sheet_demo/pages/notification_pages/local_notification_page.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class NotificationOptionPage extends StatefulWidget {
  const NotificationOptionPage({Key key}) : super(key: key);

  @override
  _NotificationOptionPageState createState() => _NotificationOptionPageState();
}

class _NotificationOptionPageState extends State<NotificationOptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).notificationAppbar),
      body: Center(
        child: Container(
          height: height * 0.3,
          width: width * 0.8,
          decoration: BoxDecoration(
              color: ColorResource.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorResource.themeColor, width: 2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              commonMaterialButton(
                  text: 'Firebase Notification',
                  color: ColorResource.white,
                  textColor: ColorResource.themeColor,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FirebaseNotification()));
                  }),
              commonMaterialButton(
                  text: 'Local Notification',
                  color: ColorResource.white,
                  textColor: ColorResource.themeColor,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocalNotification()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
