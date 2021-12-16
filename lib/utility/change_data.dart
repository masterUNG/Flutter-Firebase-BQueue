import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChangeData {
  Timestamp time;

  ChangeData({this.time});

  String changeTimeToString() {
    DateFormat dateFormat = DateFormat('dd/MMM/yyyy HH:mm');
    String timeStr = dateFormat.format(time.toDate());
    return timeStr;
  }
}
