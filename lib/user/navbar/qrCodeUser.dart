import 'package:flutter/material.dart';

// import 'package:qrscan/qrscan.dart' as scanner;

class QrCodeUser extends StatefulWidget {
  const QrCodeUser({Key key}) : super(key: key);

  @override
  _QrCodeUserState createState() => _QrCodeUserState();
}

class _QrCodeUserState extends State<QrCodeUser> {
  String scanresult;

  // scanResult() async {
  //   String scanResult = await scanner.scan();
  //   setState(
  //     () {
  //       scanresult = scanResult;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          scanresult == null
              ? Text(
                  'No Data',
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
