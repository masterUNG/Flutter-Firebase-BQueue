import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';

class ListQueue extends StatefulWidget {
  @override
  _ListQueueState createState() => _ListQueueState();
}

class _ListQueueState extends State<ListQueue> {
  RestaurantModel restaurantModel;
  UserModel userModel;
  List<QueueModel> queueModel = [];
  List<Widget> widgets = [];

  String uidUser, uidRest, name, image, address, date, time, nameUser, nameRest;
  int index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // readDataRes();
    readUidLogin();
    readDataRes();
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
            await FirebaseFirestore.instance
                .collection('restaurantTable')
                .doc(uidRest)
                .collection('restaurantQueueTable')
                .snapshots()
                .listen(
              (event) async {
                setState(() {
                  for (var item in event.docs) {
                    QueueModel queueModels = QueueModel.fromMap(
                      item.data(),
                    );
                    queueModel.add(queueModels);

                    // // setState(() {
                    // //   widgets.add(listWidget(queueModels, index));
                    // // });
                    // index++;

                    // for (var i = 1; i < event.docs.length; i++) {
                    //   queueModels.hashCode.isEven.toString();

                    //   i++;
                    //   print(i);
                    // }
                    // print('QueueModel is ===>>> $queueModels');
                    // print(queueModel);
                    // print('#####  I ===>>> $queueModels #####');
                  }
                });
                print(queueModel);
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
        // body: ListView.builder(
        //   itemCount: queueModel.length,
        //   itemBuilder: (context, index) => GestureDetector(
        //     onTap: () {},
        //     child: Container(
        //       padding: EdgeInsets.all(5),
        //       child: Card(
        //         child: Column(
        //           children: [
        //             Text(nameUser),
        //             Text(time),
        //             Text(date),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // body: listWidget(QueueModel(), index),
        );
  }
}
