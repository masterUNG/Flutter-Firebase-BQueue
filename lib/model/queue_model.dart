// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QueueModel {
  final String nameRest;
  final String date;
  final Timestamp time;
  final String peopleAmount;
  final String tableType;
  final String nameUser;
  final String uidUser;
  final String uidRest;
  final int queueAmount;
  final bool queueStatus;
  final String tokenUser;
  final String urlImageRest;
  QueueModel({
     this.nameRest,
     this.date,
     this.time,
     this.peopleAmount,
     this.tableType,
     this.nameUser,
     this.uidUser,
     this.uidRest,
     this.queueAmount,
     this.queueStatus,
     this.tokenUser,
     this.urlImageRest,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nameRest': nameRest,
      'date': date,
      'time': time,
      'peopleAmount': peopleAmount,
      'tableType': tableType,
      'nameUser': nameUser,
      'uidUser': uidUser,
      'uidRest': uidRest,
      'queueAmount': queueAmount,
      'queueStatus': queueStatus,
      'tokenUser': tokenUser,
      'urlImageRest': urlImageRest,
    };
  }

  factory QueueModel.fromMap(Map<String, dynamic> map) {
    return QueueModel(
      nameRest: (map['nameRest'] ?? '') as String,
      date: (map['date'] ?? '') as String,
      time: map['time'],
      peopleAmount: (map['peopleAmount'] ?? '') as String,
      tableType: (map['tableType'] ?? '') as String,
      nameUser: (map['nameUser'] ?? '') as String,
      uidUser: (map['uidUser'] ?? '') as String,
      uidRest: (map['uidRest'] ?? '') as String,
      queueAmount: (map['queueAmount'] ?? 0) as int,
      queueStatus: (map['queueStatus'] ?? false) as bool,
      tokenUser: (map['tokenUser'] ?? '') as String,
      urlImageRest: (map['urlImageRest'] ?? '') as String,
    );
  }

  factory QueueModel.fromJson(String source) => QueueModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
