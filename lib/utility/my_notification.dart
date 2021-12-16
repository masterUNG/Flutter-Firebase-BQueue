import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';

class MyNotificagion {
  BuildContext context;
  MyNotificagion({@required BuildContext context});

  Future<void> forNotification() async {
    // for FontEnd Service
    FirebaseMessaging.onMessage.listen((event) {
      String titleNoti = event.notification.title;
      String bodyNoti = event.notification.body;
      print(
          '@@ from FontEnd user titleNoti = $titleNoti, bodyNoti = $bodyNoti');
      normalDialog(context, 'Have Noti ==> $titleNoti');
    });

    // for BackEnd Service
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String titleNoti = event.notification.title;
      String bodyNoti = event.notification.body;
      print(
          '@@ form BackEnd user titleNoti = $titleNoti, bodyNoti = $bodyNoti');
    });
  }
}
