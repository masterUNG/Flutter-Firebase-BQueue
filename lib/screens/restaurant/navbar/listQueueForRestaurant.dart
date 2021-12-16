import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/utility/change_data.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class ListQueueForRestaurant extends StatefulWidget {
  const ListQueueForRestaurant({Key key}) : super(key: key);

  @override
  _ListQueueForRestaurantState createState() => _ListQueueForRestaurantState();
}

class _ListQueueForRestaurantState extends State<ListQueueForRestaurant> {
  var queueModels = <QueueModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllQueue();
  }

  Future<void> readAllQueue() async {
    if (queueModels.isNotEmpty) {
      queueModels.clear();
    }
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        await FirebaseFirestore.instance
            .collection('restaurantTable')
            .doc(event.uid)
            .collection('restaurantQueueTable')
            .orderBy('time', descending: true)
            .get()
            .then((value) {
          for (var item in value.docs) {
            QueueModel queueModel = QueueModel.fromMap(item.data());
            if (!queueModel.queueStatus) {
              setState(() {
                queueModels.add(queueModel);
              });
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: queueModels.isEmpty
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: queueModels.length,
              itemBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ChangeData(time: queueModels[index].time)
                            .changeTimeToString(),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String uidUser = queueModels[index].uidUser;
                          print('You Click ==> $uidUser');

                          await Firebase.initializeApp().then((value) async {
                            await FirebaseFirestore.instance
                                .collection('userTable')
                                .doc(uidUser)
                                .get()
                                .then((value) async {
                              UserModel userModel =
                                  UserModel.fromMap(value.data());
                              String token = userModel.token;
                              print('token of user ===>> $token');

                              var title = 'title from Shop';
                              var body = 'body from Shop นะครับ';

                              var path =
                                  'https://www.androidthai.in.th/mea/ungNotification.php?isAdd=true&token=$token&title=$title&body=$body';
                              await Dio().get(path).then((value) {
                                print('value ==> $value');
                              });
                            });
                          });
                        },
                        child: Text('Sent Noti'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
