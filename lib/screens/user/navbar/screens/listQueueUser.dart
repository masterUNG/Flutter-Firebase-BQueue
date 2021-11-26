import 'package:flutter/material.dart';

class ListQueueUser extends StatefulWidget {
  const ListQueueUser({Key key}) : super(key: key);

  @override
  _ListQueueUserState createState() => _ListQueueUserState();
}

class _ListQueueUserState extends State<ListQueueUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Queue User Page'),
      ),
    );
  }
}
