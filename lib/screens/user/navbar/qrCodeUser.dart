import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/screens/addQueueUser.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeUser extends StatefulWidget {
  const QrCodeUser({Key key}) : super(key: key);

  @override
  _QrCodeUserState createState() => _QrCodeUserState();
}

class _QrCodeUserState extends State<QrCodeUser> {

  String scanresult;
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController qrViewController;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrViewController.pauseCamera();
    } else if (Platform.isIOS) {
      qrViewController.resumeCamera();
    }
  }

  @override
  void dispose() {
    qrViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController qrViewController) {
                this.qrViewController = qrViewController;
                qrViewController.scannedDataStream.listen((event) async {
                  if (scanresult == null) {
                    scanresult = event.code;
                    print('## scanresult ==> $scanresult');

                    await Firebase.initializeApp().then((value) async {
                      await FirebaseFirestore.instance
                          .collection('restaurantTable')
                          .doc(scanresult)
                          .get()
                          .then((value) {
                        if (value.data() != null) {
                          RestaurantModel restaurantModel =
                              RestaurantModel.fromMap(value.data());

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddQueueUser(
                                model: restaurantModel,
                                uidRest: scanresult,
                              ),
                            ),
                          ).then((value) => scanresult = null);
                        } else {
                          normalDialog(context, 'No QR Code');
                          scanresult = null;
                        }
                      });
                    });
                  }
                });
              },
            ),
          ),
          Divider(),
          scanresult == null
              ? Text(
                  'No Data 123',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
              : Text(
                  scanresult,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  // scanResult();
                },
                child: Text('Scan')),
          ),
        ],
      ),
    );
  }
}
