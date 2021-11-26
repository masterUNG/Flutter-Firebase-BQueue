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
  QueueModel({
     this.nameRest,
     this.date,
     this.time,
     this.peopleAmount,
     this.tableType,
     this.nameUser,
     this.uidUser,
     this.queueAmount,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel.fromJson(String source) => QueueModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QueueModel(nameRest: $nameRest, date: $date, time: $time, peopleAmount: $peopleAmount, tableType: $tableType, nameUser: $nameUser, uidUser: $uidUser, queueAmount: $queueAmount)';
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
      other.queueAmount == queueAmount;
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
      queueAmount.hashCode;
  }
}
