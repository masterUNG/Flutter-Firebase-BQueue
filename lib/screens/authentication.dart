import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/index_restaurant_nav.dart';
import 'package:flutter_application_beng_queue_app/screens/user/indexUserNav.dart';
import 'package:flutter_application_beng_queue_app/screens/register.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  double screens;
  bool statusRedEye = true;
  String email, password, name, uid, avatarUrl;
  bool status = true;
  String typeUser = 'user';

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<Null> checkStatus() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            if (event != null) {
              String uid = event.uid;
              // print('uid = $uid');
              FirebaseFirestore.instance
                  .collection('userTable')
                  .doc(uid)
                  .snapshots()
                  .listen(
                (event) {
                  UserModel model = UserModel.fromMap(event.data());
                  // print('type = ${model.userType}');
                  switch (model.userType) {
                    case 'restaurant':
                      routeToPage(RestaurantNVA());
                      break;
                    case 'user':
                      routeToPage(UserNVA());
                      break;

                    default:
                      // print('### Con not Type ###');
                      routeToPage(Authentication());
                      break;
                  }
                },
              );
            } else {
              setState(
                () {
                  status = false;
                },
              );
            }
          },
        );
      },
    );
  }

  void routeToPage(Widget widget) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    screens = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 450,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: screens*0.4,
                        child: Image.asset(
                      'images/logo.png',
                      width: screens*0.4,
                    )),
                    emailForm(),
                    prasswordForm(),
                    loginButton(),
                    signinWithGoogle(),
                    // signinWithFacebook(),
                    textRegister(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signinWithFacebook() {
    return Container(
      width: screens * 0.55,
      child: SignInButton(
        Buttons.Facebook,
        onPressed: () {},
      ),
    );
  }

  Widget signinWithGoogle() {
    return Container(
      width: screens * 0.55,
      margin: EdgeInsets.only(top: 10),
      child: SignInButton(
        Buttons.Google,
        onPressed: () {
          checkSingInWithGoogle();
        },
      ),
    );
  }

  Future<Null> checkSingInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    await Firebase.initializeApp().then(
      (value) async {
        await _googleSignIn.signIn().then(
          (value) async {
            name = value.displayName;
            email = value.email;
            avatarUrl = value.photoUrl;

            await value.authentication.then(
              (value) async {
                AuthCredential authCredential = GoogleAuthProvider.credential(
                  idToken: value.idToken,
                  accessToken: value.accessToken,
                );

                await FirebaseAuth.instance
                    .signInWithCredential(authCredential)
                    .then(
                  (value) async {
                    uid = value.user.uid;
                    // print(
                    //     'Login With gmail Success Name == $name Email == $email Uid == $uid');

                    await FirebaseFirestore.instance
                        .collection('userTable')
                        .doc(uid)
                        .snapshots()
                        .listen((event) {
                      // print('Event ===>>> ${event.data()}');
                      if (event.data() == null) {
                        // Call TypeUser

                        callTypeUserDialog();
                      } else {
                        // Route to TypeUser
                        // print('Route Type User');
                      }
                    });
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Null> callTypeUserDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: ListTile(
              leading: Container(
                  width: 40, height: 40, child: Image.asset('images/logo.png')),
              title: Text('Type User'),
              subtitle: Text('Please choose type'),
            ),
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    RadioListTile(
                      activeColor: Colors.red,
                      value: 'user',
                      groupValue: typeUser,
                      onChanged: (value) {
                        setState(() {
                          typeUser = value;
                        });
                      },
                      title: Text('For User'),
                    ),
                    RadioListTile(
                      activeColor: Colors.red,
                      value: 'restaurant',
                      groupValue: typeUser,
                      onChanged: (value) {
                        setState(() {
                          typeUser = value;
                        });
                      },
                      title: Text('For Restaurant'),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // print(
                  //     ' Name == $name, TypeUser == $typeUser, Email == $email, Uid == $uid');
                  insertToCloudFirestore();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Null> insertToCloudFirestore() async {
    UserModel userModel = UserModel(
        name: name, email: email, userType: typeUser, imageProfile: avatarUrl);
    Map<String, dynamic> data = userModel.toMap();

    await Firebase.initializeApp().then(
      (value) async {
        FirebaseFirestore.instance
            .collection('userTable')
            .doc(uid)
            .set(data)
            .then(
          (value) async {
            switch (typeUser) {
              case 'restaurant':
                routeToPage(RestaurantNVA());
                break;
              case 'user':
                routeToPage(UserNVA());
                break;
              default:
            }
          },
        );
      },
    );
  }

  // Row showTextNameApp() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         margin: EdgeInsets.only(top: 2),
  //         child: Text(
  //           'B',
  //           style: TextStyle(
  //             fontSize: 25,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.blue,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(top: 2),
  //         child: Text(
  //           'e',
  //           style: TextStyle(
  //             fontSize: 25,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.green,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(top: 2),
  //         child: Text(
  //           'n',
  //           style: TextStyle(
  //               fontSize: 25, fontWeight: FontWeight.bold, color: Colors.amber),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(top: 2),
  //         child: Text(
  //           'g',
  //           style: TextStyle(
  //               fontSize: 25,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.orange),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(top: 2),
  //         child: Text(
  //           'Q',
  //           style: TextStyle(
  //               fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Container loginButton() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 15),
      width: screens*0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if ((email?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            normalDialog(
                context, 'Please enter your information in all fields.');
          } else {
            checkAuthen();
          }
        },
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {});
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) async {
        String uid = value.user.uid;
        await FirebaseFirestore.instance
            .collection('userTable')
            .doc(uid)
            .snapshots()
            .listen(
          (event) {
            UserModel model = UserModel.fromMap(event.data());
            switch (model.userType) {
              case 'restaurant':
                routeToPage(RestaurantNVA());
                break;
              case 'user':
                routeToPage(UserNVA());
                break;
              default:
                print('### Con not Type ###');
                routeToPage(Authentication());
                break;
            }
          },
        );
      },
    ).catchError(
      (value) {
        normalDialog(context, value.message);
      },
    );
  }

  // Widget signInFacebook() => Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: SignInButton(Buttons.FacebookNew, onPressed: () {}),
  //     );

  // Widget signInGoogle() => Container(
  //       margin: EdgeInsets.only(top: 10),
  //       child: SignInButton(Buttons.GoogleDark, onPressed: () {}),
  //     );

  Container textRegister() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You don't have an account",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterApp(),
              ),
            ),
            child: Text(
              'Create now!',
              style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  Widget emailForm() => Container(
        width: MediaQuery.of(context).size.width*0.85,
        margin: EdgeInsets.only(top: 10),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => email = value.trim(),
          decoration: InputDecoration(
            label: Text(
              'Please enter your email',
              style: TextStyle(color: Colors.black54),
            ),
            prefixIcon: Icon(
              Icons.email_rounded,
              color: Colors.redAccent,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
      );

  Widget prasswordForm() => Container(
        width: screens * 0.85,
        margin: EdgeInsets.only(top: 10),
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: statusRedEye,
          decoration: InputDecoration(
            label: Text(
              'Please enter your passworld',
              style: TextStyle(color: Colors.black54),
            ),
            prefixIcon: Icon(
              Icons.password_rounded,
              color: Colors.redAccent,
            ),
            suffixIcon: IconButton(
              icon: statusRedEye
                  ? Icon(
                      Icons.visibility_off_rounded,
                      color: Colors.redAccent,
                    )
                  : Icon(
                      Icons.visibility_rounded,
                      color: Colors.redAccent,
                    ),
              onPressed: () {
                setState(
                  () {
                    statusRedEye = !statusRedEye;
                  },
                );
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
      );
}
