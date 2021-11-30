import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class ListQueueUser extends StatefulWidget {
  const ListQueueUser({Key key}) : super(key: key);

  @override
  _ListQueueUserState createState() => _ListQueueUserState();
}

class _ListQueueUserState extends State<ListQueueUser> {
  RestaurantModel restaurantModel;
  UserModel userModel;
  List<QueueModel> queueModels = [];
  List<String> uidRests = [];
  bool statusLoad = true;
  bool statusHaveData = true;

  String uidUser, uidRest, name, image, address, date, time, nameUser, nameRest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // readDataRes();
    readUidLogin();
    readDataRes();
    readQueueData();
  }

  Future<Null> readQueueData() async {
    FirebaseFirestore.instance
        .collection("restaurantQueueTable")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var data = result.data();
        print("uidUser");
        print(data["uidUser"]);
      });
    });
  }

  Future<Null> readDataRes() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen(
        (event) async {
          uidRest = event.uid;
        },
      );
    });
  }

  Future<Null> readUidLogin() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            uidUser = event.uid;
            // print('Uid = $uidUser');
            await FirebaseFirestore.instance
                .collection('userTable')
                .doc(uidUser)
                .snapshots()
                .listen(
              (event) {
                setState(
                  () {
                    userModel = UserModel.fromMap(event.data());
                    String nameLogin = userModel.name;
                    // print('NameLogin ====>>>> $nameLogin');
                  },
                );
              },
            );
            statusHaveData = true;
            if (queueModels.length != null) {
              queueModels.clear();
            } else {
              MyStyle().showProgress();
            }
            await FirebaseFirestore.instance
                .collection('restaurantTable')
                .doc(uidRest)
                .collection('restaurantQueueTable')
                .snapshots()
                .listen(
              (event) async {
                setState(() {
                  statusLoad = false;
                });
                int index = 0;
                if (event.docs.length == 0) {
                  setState(() {
                    statusHaveData = false;
                  });
                } else {
                  for (var item in event.docs) {
                    String uidRest = item.id;
                    uidRests.add(uidRest);
                    QueueModel qModel = QueueModel.fromMap(
                      item.data(),
                    );

                    if (qModel != null) {
                      setState(() {
                        queueModels.add(qModel);
                      });
                    } else {}
                  }
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: statusLoad
          ? MyStyle().showProgress()
          : statusHaveData
              ? ListView.builder(
                  itemCount: queueModels.length,
                  itemBuilder: (context, index) => Container(
                    height: 160,
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Card(
                      shadowColor: Colors.red,
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            child: Image.asset('images/logo.png'),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.58,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.56,
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                          'You : ${queueModels[index].nameUser}'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.56,
                                        margin: EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Text(
                                            'Table Type : ${queueModels[index].tableType}')),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.56,
                                        margin: EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Text(
                                            'Number Of People : ${queueModels[index].peopleAmount}')),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 5,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.56,
                                      child: Text(
                                          'Queue Number : ${queueModels[index].queueAmount}'),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    normalDialog(context, 'Notification User');
                                  },
                                  child: Text('SentNotification'),
                                )
                              ],
                            ),
                          ),

                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.ac_unit,
                          //     color: Colors.red,
                          //     size: 35,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text('No Queue'),
                ),
    );
  }
}
