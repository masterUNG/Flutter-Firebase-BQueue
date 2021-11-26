import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/user/navbar/screens/addQueueUser.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class ListRestaurant extends StatefulWidget {
  const ListRestaurant({Key key}) : super(key: key);

  @override
  _ListRestaurantState createState() => _ListRestaurantState();
}

class _ListRestaurantState extends State<ListRestaurant> {
  List<RestaurantModel> restaurantModels = [];
  UserModel userModel;
  List<Widget> widgets = [];
  List<String> uidRests = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataRestaurant();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            String uid = event.uid;
            await FirebaseFirestore.instance
                .collection('userTable')
                .doc(uid)
                .snapshots()
                .listen(
              (event) {
                setState(() {
                  userModel = UserModel.fromMap(
                    event.data(),
                  );

                  print('Name Login ===>>> ${userModel.name}');
                });
              },
            );
          },
        );
      },
    );
  }

  Future<Null> readDataRestaurant() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('restaurantTable')
          .snapshots()
          .listen((event) {
        int index = 0;
        for (var item in event.docs) {
          String uidRest = item.id;
          uidRests.add(uidRest);
          print('UidRestaurane ===>>> $uidRest');
          RestaurantModel restaurantModel =
              RestaurantModel.fromMap(item.data());
          print('NameRestaurant ===>>> ${restaurantModel.nameRes}');
          print('Adderss ===>>> ${restaurantModel.address}');
          print('UrlPicture ===>>> ${restaurantModel.urlImageRes}');
          setState(() {
            restaurantModels.add(restaurantModel);
            //  widgets.add(creatWidget(model, index));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: restaurantModels.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddQueueUser(
                        model: restaurantModels[index],
                        uidRest: uidRests[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text('Hello World'),
                      // showImage(
                      //   RestaurantModel(),
                      // ),
                      // showTextname(
                      //   RestaurantModel(),
                      // ),
                    ],
                  ),
                ),
              ),
            ),

      //  : Container(
      //   margin: EdgeInsets.only(left: 15, top: 10, right: 15),
      //   child: GridView.extent(
      //     maxCrossAxisExtent: 220,
      //     children: widgets,
      //   ),
    );
  }

  //  Widget creatWidget(RestaurantModel model, int index) => GestureDetector(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => AddQueueRestaurant(
  //               model: restaurantModel[index],
  //               uidRest: uidRests[index],
  //             ),
  //           ),
  //         );
  //       },
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             showImage(model),
  //             showTextname(model),
  //           ],
  //         ),
  //       ),
  //     );

  Widget showTextname(RestaurantModel model) => Text(
        model.nameRes,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      );

  Widget showImage(RestaurantModel model) => Center(
        child: Image.network(
          model.urlImageRes,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.20,
          height: MediaQuery.of(context).size.width * 0.20,
        ),
      );
}
