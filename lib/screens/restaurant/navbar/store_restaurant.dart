import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/add_restaurant.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/editAddreddRestaurant.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/editNameRestrant.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/editPhotoRestaurant.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';
import 'package:image_picker/image_picker.dart';

class StoreRestaurant extends StatefulWidget {
  @override
  _StoreRestaurantState createState() => _StoreRestaurantState();
}

class _StoreRestaurantState extends State<StoreRestaurant> {
  RestaurantModel restaurantModel;
  UserModel userModel;
  String uidUser, uidRest, name, image, address;
  bool status = true;
  File file;

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
          editNameRest(),
          editAddressRest(),
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

  Widget showImage() => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPhotoRestaurant(),
            ),
          );
        },
        child: Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: 300,
            height: 300,
            child: Card(
                child: Image.network(
              restaurantModel.urlImageRes,
              fit: BoxFit.cover,
            ))),
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

  Widget editAddressRest() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(
        left: 10,
        right: 20,
        top: 20,
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditAddressRestaurant(),
            ),
          );
        },
        leading: Icon(
          Icons.fmd_good_sharp,
          size: 30,
          color: Colors.red,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.red,
        ),
        title: Text(
          restaurantModel.address,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget editNameRest() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(
        left: 10,
        right: 20,
        top: 20,
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNameRestaurant(),
            ),
          );
        },
        leading: Icon(
          Icons.store_mall_directory_sharp,
          size: 30,
          color: Colors.red,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.red,
        ),
        title: Text(
          restaurantModel.nameRes,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
