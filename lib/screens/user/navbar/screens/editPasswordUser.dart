import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class EditPasswordUser extends StatefulWidget {
  const EditPasswordUser({Key key}) : super(key: key);

  @override
  _EditPasswordUserState createState() => _EditPasswordUserState();
}

class _EditPasswordUserState extends State<EditPasswordUser> {
  double screens;
  UserModel userModel;
  String uidUser, password, pass, newPassword, conFirmPassword;
  bool statusRedEy = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataUserLogin();
  }

  Future<Null> readDataUserLogin() async {
    Firebase.initializeApp().then(
      (value) async {
        FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            uidUser = event.uid;
            FirebaseFirestore.instance
                .collection('userTable')
                .doc(uidUser)
                .snapshots()
                .listen(
              (event) async {
                setState(
                  () {
                    userModel = UserModel.fromMap(
                      event.data(),
                    );
                  },
                );
                password = userModel.password;
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screens = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (userModel.password == pass) {
                  normalDialog(context, 'Password is not True');
                } else if (conFirmPassword == newPassword) {
                  normalDialog(context, 'New password is not True');
                } else if ((pass?.isEmpty == true) ||
                    (newPassword?.isEmpty == true) ||
                    (conFirmPassword?.isEmpty == true)) {
                  normalDialog(context, 'Please enter your textfield');
                } else {
                  upDatePassword();
                }
              },
              icon: Icon(
                Icons.save,
                size: 30,
              ))
        ],
        title: Container(
          margin: EdgeInsets.only(right: 10),
          child: Center(
            child: Text('Edit password'),
          ),
        ),
      ),
      body: password == null
          ? MyStyle().showProgress()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    prasswordForm(),
                    newPrasswordForm(),
                    confrimPrasswordForm(),
                  ],
                ),
              ],
            ),
    );
  }

  Future<Null> upDatePassword() async {
    await Firebase.initializeApp().then(
      (value) async {
        FirebaseAuth.instance.currentUser
            .updatePassword(newPassword)
            .then((value) {
          FirebaseFirestore.instance
              .collection('userTable')
              .doc(uidUser)
              .update(
            {"password": newPassword},
          ).then(
            (value) async {
              normalDialog(context, 'Update Success');
            },
          );
          normalDialog(context, 'Update Password Success');
        }).catchError(
          (onErro) => normalDialog(context, onErro),
        );
      },
    );
  }

  Widget prasswordForm() => Container(
        width: screens * 0.8,
        margin: EdgeInsets.only(top: 10),
        child: TextField(
          onChanged: (value) => pass = value.trim(),
          obscureText: statusRedEy,
          decoration: InputDecoration(
            label: Text(
              'Please enter your password',
              style: TextStyle(color: Colors.black54),
            ),
            prefixIcon: Icon(
              Icons.password_rounded,
              color: Colors.red,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
      );

  Widget newPrasswordForm() => Container(
        width: screens * 0.8,
        margin: EdgeInsets.only(top: 10),
        child: TextField(
          onChanged: (value) => newPassword = value.trim(),
          obscureText: statusRedEy,
          decoration: InputDecoration(
            label: Text(
              'Please enter your new password',
              style: TextStyle(color: Colors.black54),
            ),
            prefixIcon: Icon(
              Icons.password_rounded,
              color: Colors.red,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
      );

  Widget confrimPrasswordForm() => Container(
        width: screens * 0.8,
        margin: EdgeInsets.only(top: 10),
        child: TextField(
          onChanged: (value) => conFirmPassword = value.trim(),
          obscureText: statusRedEy,
          decoration: InputDecoration(
            label: Text(
              'Confirm password',
              style: TextStyle(color: Colors.black54),
            ),
            prefixIcon: Icon(
              Icons.password_rounded,
              color: Colors.red,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
      );
}
