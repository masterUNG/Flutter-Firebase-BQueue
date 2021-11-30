import 'dart:convert';

class QueueModel {
  final String nameRest;
  final String date;
  final String time;
  final String peopleAmount;
  final String tableType;
  final String nameUser;
  final String uidUser;
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
     this.queueAmount,
     this.queueStatus,
     this.tokenUser,
     this.urlImageRest,
  });
 

  QueueModel copyWith({
    String nameRest,
    String date,
    String time,
    String peopleAmount,
    String tableType,
    String nameUser,
    String uidUser,
    int queueAmount,
    bool queueStatus,
    String tokenUser,
    String urlImageRest,
  }) {
    return QueueModel(
      nameRest: nameRest ?? this.nameRest,
      date: date ?? this.date,
      time: time ?? this.time,
      peopleAmount: peopleAmount ?? this.peopleAmount,
      tableType: tableType ?? this.tableType,
      nameUser: nameUser ?? this.nameUser,
      uidUser: uidUser ?? this.uidUser,
      queueAmount: queueAmount ?? this.queueAmount,
      queueStatus: queueStatus ?? this.queueStatus,
      tokenUser: tokenUser ?? this.tokenUser,
      urlImageRest: urlImageRest ?? this.urlImageRest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameRest': nameRest,
      'date': date,
      'time': time,
      'peopleAmount': peopleAmount,
      'tableType': tableType,
      'nameUser': nameUser,
      'uidUser': uidUser,
      'queueAmount': queueAmount,
      'queueStatus': queueStatus,
      'tokenUser': tokenUser,
      'urlImageRest': urlImageRest,
    };
  }

  factory QueueModel.fromMap(Map<String, dynamic> map) {
    return QueueModel(
      nameRest: map['nameRest'],
      date: map['date'],
      time: map['time'],
      peopleAmount: map['peopleAmount'],
      tableType: map['tableType'],
      nameUser: map['nameUser'],
      uidUser: map['uidUser'],
      queueAmount: map['queueAmount'],
      queueStatus: map['queueStatus'],
      tokenUser: map['tokenUser'],
      urlImageRest: map['urlImageRest'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel.fromJson(String source) => QueueModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QueueModel(nameRest: $nameRest, date: $date, time: $time, peopleAmount: $peopleAmount, tableType: $tableType, nameUser: $nameUser, uidUser: $uidUser, queueAmount: $queueAmount, queueStatus: $queueStatus, tokenUser: $tokenUser, urlImageRest: $urlImageRest)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QueueModel &&
      other.nameRest == nameRest &&
      other.date == date &&
      other.time == time &&
      other.peopleAmount == peopleAmount &&
      other.tableType == tableType &&
      other.nameUser == nameUser &&
      other.uidUser == uidUser &&
      other.queueAmount == queueAmount &&
      other.queueStatus == queueStatus &&
      other.tokenUser == tokenUser &&
      other.urlImageRest == urlImageRest;
  }

  @override
  int get hashCode {
    return nameRest.hashCode ^
      date.hashCode ^
      time.hashCode ^
      peopleAmount.hashCode ^
      tableType.hashCode ^
      nameUser.hashCode ^
      uidUser.hashCode ^
      queueAmount.hashCode ^
      queueStatus.hashCode ^
      tokenUser.hashCode ^
      urlImageRest.hashCode;
  }
}
