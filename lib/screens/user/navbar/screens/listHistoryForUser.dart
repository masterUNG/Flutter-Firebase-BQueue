import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';

class ListHistoryUser extends StatefulWidget {
  const ListHistoryUser({Key key}) : super(key: key);

  @override
  _ListHistoryUserState createState() => _ListHistoryUserState();
}

class _ListHistoryUserState extends State<ListHistoryUser> {
  RestaurantModel restaurantModel;
  List<QueueModel> queueModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseAuth.instance.authStateChanges().listen((event) async {
          String uidRest = event.uid;
          await FirebaseFirestore.instance
              .collection('restaurantTable')
              .doc(uidRest)
              .collection('restaurantQueueTable')
              .snapshots()
              .listen(
            (event) {
              int index = 0;
              for (var item in event.docs) {
                String uidRest = item.id;
                print(uidRest);

                QueueModel model = QueueModel.fromMap(item.data());
                setState(() {
                  queueModel.add(model);
                });
                print(model.tableType);
                // print('Uid NameRes is ===>>> $uidRests');
                // print('NameRestaurant is ===>>> ${model.nameRes}');
                // print('Adderss  is ===>>> ${model.address}');
                // print('UrlPicture is ===>>> ${model.urlImageRes}');
                print('###########$queueModel');
              }
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('HistoryForUser'),
    ));
  }
}
