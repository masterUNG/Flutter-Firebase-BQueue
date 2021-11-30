import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/screens/addQueueUser.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';


class StoreUser extends StatefulWidget {
  @override
  _StoreUserState createState() => _StoreUserState();
}

class _StoreUserState extends State<StoreUser> {
  List<RestaurantModel> restaurantModel = [];
  List<Widget> widgets = [];
  List<String> uidRests = [];
  String urlImage;
  double sceens;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseFirestore.instance
            .collection('restaurantTable')
            .snapshots()
            .listen(
          (event) {
            int index = 0;
            for (var item in event.docs) {
              String uidRest = item.id;
              uidRests.add(uidRest);
              // print('Uid NameRes is ===>>> $uidRests');
              RestaurantModel model = RestaurantModel.fromMap(item.data());
              restaurantModel.add(model);
              // print('NameRestaurant is ===>>> ${model.nameRes}');
              // print('Adderss  is ===>>> ${model.address}');
              // print('UrlPicture is ===>>> ${model.urlImageRes}');
              setState(
                () {
                  widgets.add(creatWidget(model, index));
                },
              );
              index++;
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    sceens = MediaQuery.of(context).size.width;
    return Scaffold(
      body: widgets.length == 0
          ? MyStyle().showProgress()
          : Container(
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: GridView.extent(
                maxCrossAxisExtent: sceens*0.5,
                children: widgets,
              ),
            ), //   ),
    );
  }

  Widget creatWidget(RestaurantModel model, int index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddQueueUser(
                model: restaurantModel[index],
                uidRest: uidRests[index],
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Card(
            shadowColor: Colors.red[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showImage(model),
                showTextname(model),
              ],
            ),
          ),
        ),
      );

  Widget showTextname(RestaurantModel model) => Text(
        model.nameRes,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      );

  Widget showImage(RestaurantModel model) => Center(
        child: Card(
          color: Colors.red[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          child: ClipOval(
            child: Image.network(
              model.urlImageRes,
              fit: BoxFit.fill,
              width: sceens * 0.30,
              height: sceens * 0.30,
            ),
          ),
        ), 
      );
}
