import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AddQueueUser extends StatefulWidget {
  final RestaurantModel model;
  final String uidRest;
  DateTime dateTime;
  AddQueueUser({Key key, this.model, this.uidRest}) : super(key: key);

  @override
  _AddQueueUserState createState() => _AddQueueUserState();
}

class _AddQueueUserState extends State<AddQueueUser> {
  String uidRes, typeTable, nameLogin, uidUser, date, time, peopleAmount;

  bool statusHaveData = true;
  bool statusNoData = true;

  // Model
  RestaurantModel restaurantModel;
  UserModel userModel;
  QueueModel queueModel;

  double screens;
  int amount = 0;
  int queueAmount = 0;

  // DateTime
  var dateTimeNow;
  DateFormat dateFormat;
  DateFormat timeFormat;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataUidLogin();
    restaurantModel = widget.model;
    uidRes = widget.uidRest;
    dateFormat = new DateFormat.yMd();
    timeFormat = new DateFormat.Hms();
    initializeDateFormatting();
  }

  Future<Null> readDataUidLogin() async {
    await Firebase.initializeApp().then(
      (value) async {
        FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            uidUser = event.uid;
            FirebaseFirestore.instance
                .collection('userTable')
                .doc(uidUser)
                .snapshots()
                .listen(
              (event) async {
                setState(
                  () {
                    userModel = UserModel.fromMap(
                      event.data(),
                    );
                    nameLogin = userModel.name;
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dateTimeNow = DateTime.now();
    screens = MediaQuery.of(context).size.width;
    // print('DateTime Now $now');
    date = dateFormat.format(dateTimeNow);
    time = timeFormat.format(dateTimeNow);

    // print('Date is $date');
    // print('Time is $time');
    // print('Uid User $uidUser');
    // print('Name Login is $nameLogin');
    // print('Uid Rest $uidRes');
    // print('Name Rest is ${restaurantModel.nameRes}');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 40,
          ),
        ),
        backgroundColor: Colors.red,
        title: Container(
          margin: EdgeInsets.only(right: 75),
          child: Center(
            child: Text('Reserve queueu'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // TextButton(
              //   onPressed: () {
              //     adddQueueAmount();
              //   },
              //   child: Text('AddQueueAmount'),
              // ),
              // showLogoApp(context),
              showCardRestaurant(context),
              title(),
              methodTypeUser(),
              methodTypeRestaurant(),
              showTextNumberOfPeople(),
              textFieldNumberOfPeople(),
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Container showLogoApp(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Image.asset('images/logo.png'),
    );
  }

  Container showCardRestaurant(BuildContext context) {
    return Container(margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(10),
      height: 200,
      child: Card(
        shadowColor: Colors.red[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 180,
              // color: Colors.redAccent,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(restaurantModel.urlImageRes),
            ),
            Container(
              height: 180,
              // color: Colors.redAccent,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_rounded,
                        color: Colors.red,
                      ),
                      Text(
                        '  ${restaurantModel.nameRes}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.place_rounded,
                        color: Colors.red,
                      ),
                      Text(
                        '  ${restaurantModel.address}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.hourglass_bottom,
                        color: Colors.red,
                      ),
                      Text(
                        '  Wait in queue $amount',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textFieldNumberOfPeople() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) => peopleAmount = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.red,
          ),
          label: Text(
            'Number of people',
            style: TextStyle(color: Colors.black54),
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget showTextNumberOfPeople() => Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25,top: 15,),
            child: Text(
              'Please enter your number of people',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );

  Container methodTypeUser() {
    return Container(
      width: screens * 0.6,
      child: Transform.scale(
        scale: 1.1,
        child: RadioListTile(
          activeColor: Colors.red,
          value: 'table1-4',
          groupValue: typeTable,
          onChanged: (value) {
            setState(() {
              typeTable = value;
            });
          },
          title: Text('For 1 - 4 people'),
        ),
      ),
    );
  }

  Container methodTypeRestaurant() {
    return Container(
      width: screens * 0.6,
      child: Transform.scale(
        scale: 1.1,
        child: RadioListTile(
          activeColor: Colors.red,
          value: 'table5',
          groupValue: typeTable,
          onChanged: (value) {
            setState(() {
              typeTable = value;
            });
          },
          title: Text('5 people or more'),
        ),
      ),
    );
  }

  // Container methodTypeOther() {
  //   return Container(
  //     width: screens * 0.8,
  //     child: RadioListTile(
  //       value: 'other',
  //       groupValue: typeTable,
  //       onChanged: (value) {
  //         setState(() {
  //           typeTable = value;
  //         });
  //       },
  //       title: Text('อื่นๆ'),
  //     ),
  //   );
  // }

  Container title() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      width: screens * 0.8,
      child: Text(
        'Table type :',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 30),
      width: screens * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if ((typeTable?.isEmpty ?? true) || (peopleAmount?.isEmpty ?? true)) {
            normalDialog(
                context, 'Please you choose tabel type and number of people');
          } else {
            adddQueueAmount();
            // addReceeiveQueue();
            // Navigator.pop(context);

          }
        },
        child: Text(
          'Reserve now!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Future<Null> addReceeiveQueue() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            String uidUser = event.uid;
            QueueModel queueModel = QueueModel(
              date: date,
              time: time,
              peopleAmount: peopleAmount,
              nameRest: restaurantModel.nameRes,
              tableType: typeTable,
              uidUser: uidUser,
              nameUser: nameLogin,
              queueAmount: queueAmount,
            );
            Map<String, dynamic> data = queueModel.toMap();
            await FirebaseFirestore.instance
                .collection('restaurantTable')
                .doc(uidRes)
                .collection('restaurantQueueTable')
                .doc()
                .set(data)
                .then(
              (value) {
                // sendNotication();
                // readDatailDesk();
                normalDialog(context, 'Succress');
              },
            );
          },
        );
      },
    );
  }

  void adddQueueAmount() {
    for (var i = 0; i < 1; i++) {
      if (queueAmount < 5) {
        setState(() {
          queueAmount++;
        });
      } else {
        queueAmount = 1;
      }
    }
    print('QueueAmout == $queueAmount');
    addReceeiveQueue();
  }
}
