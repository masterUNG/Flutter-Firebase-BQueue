import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/screens/detail_queue_for_user.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';
import 'package:intl/intl.dart';

class ListQueueUser extends StatefulWidget {
  const ListQueueUser({Key key}) : super(key: key);

  @override
  _ListQueueUserState createState() => _ListQueueUserState();
}

class _ListQueueUserState extends State<ListQueueUser> {
  var queruModels = <QueueModel>[];
  var queruModelSorts = <QueueModel>[];
  var load = true;
  var haveQueue = false; // false => No Queue

  var times = <Timestamp>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllQuere();
  }

  Future<void> readAllQuere() async {
    if (queruModels.isNotEmpty) {
      queruModels.clear();
    }
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uidUserLogined = event.uid;
        await FirebaseFirestore.instance
            .collection('restaurantTable')
            .get()
            .then((value) async {
          setState(() {
            load = false;
          });
          for (var item in value.docs) {
            String docIdRestaurantTable = item.id;
            await FirebaseFirestore.instance
                .collection('restaurantTable')
                .doc(docIdRestaurantTable)
                .collection('restaurantQueueTable')
                .get()
                .then((value) {
              for (var item in value.docs) {
                QueueModel queueModel = QueueModel.fromMap(item.data());

                print('times ==> ${queueModel.time}');

                if (queueModel.uidUser == uidUserLogined) {
                  if (!queueModel.queueStatus) {
                    queruModels.add(queueModel);
                    times.add(queueModel.time);
                  }
                }
              }
            });
          }

          times.sort();

          for (var time in times) {
            for (var model in queruModels) {
              if (time == model.time) {
                setState(() {
                  haveQueue = true;
                  queruModelSorts.add(model);
                });
              }
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? MyStyle().showProgress()
          : haveQueue
              ? ListView.builder(
                  itemCount: queruModels.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailQueueForUser(
                            queueModel: queruModelSorts[index],
                            sumQueue: queruModels.length,
                          ),
                        ),
                      );
                    },
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(changeTimeToString(queruModelSorts[index].time)),
                              Text(queruModelSorts[index].nameUser),
                            ],
                          ),
                    )),
                  ),
                )
              : Center(
                  child: Text('No Queue'),
                ),
    );
  }

  String changeTimeToString(Timestamp time) {
    DateFormat dateFormat = DateFormat('dd/MMM/yyyy HH:mm');
    String timeStr = dateFormat.format(time.toDate());
    return timeStr;
  }
}
