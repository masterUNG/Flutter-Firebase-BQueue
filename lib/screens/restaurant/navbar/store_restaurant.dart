import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/add_restaurant.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class StoreRestaurant extends StatefulWidget {
  @override
  _StoreRestaurantState createState() => _StoreRestaurantState();
}

class _StoreRestaurantState extends State<StoreRestaurant> {
  RestaurantModel restaurantModel;
  UserModel userModel;
  String uidUser, uidRest, name, image, address;
  bool status = true;

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
                .snapshots()
                .listen(
              (event) async {
                setState(() {
                  restaurantModel = RestaurantModel.fromMap(event.data());
                });
                // print(restaurantModel);
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
      body: restaurantModel == null ? showNodata(context) : showHaveData(),
    );
  }

  Center showHaveData() {
    return Center(
      child: Column(
        children: [
          showTextRestaurant(),
          showImage(),
          showNameRestaurant(),
          showAddress(),
        ],
      ),
    );
  }

  Widget showTextRestaurant() => Container(
      margin: EdgeInsets.only(top: 15),
      child: Text(
        'My Restaurant',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.red[700]),
      ));

  Widget showAddress() => Container(
        width: MediaQuery.of(context).size.width * 0.75,
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Container(
                child: Icon(
              Icons.location_on_rounded,
              color: Colors.red,
              size: 30,
            )),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                restaurantModel.address,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );

  Widget showImage() => Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          shadowColor: Colors.red[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            padding: EdgeInsets.all(15),
            width: 200,
            height: 200,
            child: restaurantModel == null
                ? MyStyle().showLogo()
                : Container(
                    child: Image.network(
                    restaurantModel.urlImageRes,
                    fit: BoxFit.cover,
                  )),
          ),
        ),
      );

  Widget showNameRestaurant() => Container(
        width: MediaQuery.of(context).size.width * 0.75,
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Icon(
              Icons.store_rounded,
              color: Colors.red,
              size: 30,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                restaurantModel.nameRes,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );

  Center showNodata(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an restaurant data",
            style: TextStyle(fontSize: 20),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddRaetaurant(),
                )),
            child: Text(
              'Add RestaurantData',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
