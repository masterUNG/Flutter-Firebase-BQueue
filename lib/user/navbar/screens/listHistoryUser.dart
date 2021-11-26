import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<QueueModel> queueModels = [];
  RestaurantModel restaurantModel;
  String uidRestaurant;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataQueueRestaurant();
  }

  Future<Null> readDataQueueRestaurant() async {
    await Firebase.initializeApp().then(
      (value) async {
        FirebaseFirestore.instance
            .collection('restaurantQueueTable')
            .snapshots()
            .listen(
          (event) async {
            for (var item in event.docs) {
              if (item.data() != null) {
                setState(
                  () {
                    QueueModel queueModels = QueueModel.fromMap(item.data());
                  },
                );
                print(queueModels);
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('History User page'),
      ),
    );
  }
}
