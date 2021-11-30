import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/screens/user/accountUser.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/historyUser.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/notificationUser.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/qrCodeUser.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/storeUser.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class UserNVA extends StatefulWidget {
  @override
  _UserNVAState createState() => _UserNVAState();
}

class _UserNVAState extends State<UserNVA> {
  List<Widget> listWidgets = [
    StoreUser(),
    QrCodeUser(),
    HistoryUser(),
    NotificationUser(),
    // AccountUser(),
  ];
  int indexPage = 0;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    readUidLogin();
  }

  Future<Null> readUidLogin() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            String uid = event.uid;
            // print('Uid = $uid');
            await FirebaseFirestore.instance
                .collection('userTable')
                .doc(uid)
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
          },
        );
      },
    );
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
                    builder: (context) => AccountUser(),
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
      bottomNavigationBar: bottonNavigationBar(),
    );
  }

  BottomNavigationBar bottonNavigationBar() => BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.red,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: [
          storeUserNav(),
          qrCodeUserNav(),
          historyUserNav(),
          notificationUserNav(),
        ],
      );

  BottomNavigationBarItem storeUserNav() {
    return BottomNavigationBarItem(
        backgroundColor: Colors.redAccent[400],
        icon: Icon(
          Icons.store_mall_directory_sharp,
          size: 30,
        ),
        title: Text(
          'Store',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ));
  }

  BottomNavigationBarItem qrCodeUserNav() {
    return BottomNavigationBarItem(
        backgroundColor: Colors.redAccent[400],
        icon: Icon(
          Icons.qr_code_scanner_rounded,
          size: 30,
        ),
        title: Text(
          'Scan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ));
  }

  BottomNavigationBarItem historyUserNav() {
    return BottomNavigationBarItem(
        backgroundColor: Colors.redAccent[400],
        icon: Icon(
          Icons.menu_book_rounded,
          size: 30,
        ),
        title: Text(
          'List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ));
  }

  BottomNavigationBarItem notificationUserNav() {
    return BottomNavigationBarItem(
      backgroundColor: Colors.redAccent[400],
      icon: Icon(
        Icons.notifications,
        size: 30,
      ),
      title: Text(
        'Notifiction',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
