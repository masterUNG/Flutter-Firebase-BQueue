import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:intl/intl.dart';

class DetailQueueForUser extends StatefulWidget {
  final QueueModel queueModel;
  const DetailQueueForUser({Key key, @required this.queueModel})
      : super(key: key);

  @override
  _DetailQueueForUserState createState() => _DetailQueueForUserState();
}

class _DetailQueueForUserState extends State<DetailQueueForUser> {
  QueueModel queueModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.queueModel = widget.queueModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('Date => ${changeTimeToString(queueModel.time)}'),
    );
  }

  String changeTimeToString(Timestamp time) {
    DateFormat dateFormat = DateFormat('dd/MMM/yyyy HH:mm');
    String timeStr = dateFormat.format(time.toDate());
    return timeStr;
  }
}
