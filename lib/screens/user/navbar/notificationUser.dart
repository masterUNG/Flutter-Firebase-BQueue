import 'package:flutter/material.dart';

class NotificationUser extends StatefulWidget {
  const NotificationUser({Key key}) : super(key: key);

  @override
  _NotificationUserState createState() => _NotificationUserState();
}

class _NotificationUserState extends State<NotificationUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Notification For User'),
      ),
    );
  }
}
