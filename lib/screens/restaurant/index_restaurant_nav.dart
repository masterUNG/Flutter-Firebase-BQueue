import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/account_restaurant.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/listQueueForRestaurant.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/notifycationRest.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/store_restaurant.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class RestaurantNVA extends StatefulWidget {
  @override
  _RestaurantNVAState createState() => _RestaurantNVAState();
}

class _RestaurantNVAState extends State<RestaurantNVA> {
  List<Widget> listWidgets = [
    StoreRestaurant(),
    ListQueueForRestaurant(),
    NotifycationRest(),
  ];
  int indexPage = 0;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    readUidLogin();
  }

  Future<Null> readUidLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        // print('Uid = $uid');
        await FirebaseFirestore.instance
            .collection('userTable')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromMap(event.data());
            // String nameLogin = userModel.name;
            // print('NameLogin ====>>>> $nameLogin');
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: userModel == null
            ? MyStyle().showProgress()
            : Text(
                'Welcome you ${userModel.name} !',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
        actions: [
          Container(
            width: 60,
            height: 50,
            margin: EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountRestaurant(),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: ClipOval(
                  child: userModel == null
                      ? Image.asset(
                          'images/logo.png',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          userModel.imageProfile,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: listWidgets[indexPage],
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  BottomNavigationBar bottomNavigationBar() => BottomNavigationBar(
        selectedItemColor: Colors.black,
        backgroundColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: [
          storeRestaurantNav(),
          homeRestaurantNav(),
          accountRestaurantNav(),
        ],
      );

  BottomNavigationBarItem homeRestaurantNav() {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.list_alt_rounded,
        size: 30,
      ),
      title: Text(
        'List Queue',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  BottomNavigationBarItem storeRestaurantNav() {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.store_mall_directory_sharp,
        size: 30,
      ),
      title: Text(
        'Store',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  BottomNavigationBarItem accountRestaurantNav() {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.notifications,
        size: 30,
      ),
      title: Text(
        'Notifytotion',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
