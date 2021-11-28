import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';

class DetailQueueForRrst extends StatefulWidget {
  
  const DetailQueueForRrst({Key key}) : super(key: key);

  @override
  _DetailQueueForRrstState createState() => _DetailQueueForRrstState();
}

class _DetailQueueForRrstState extends State<DetailQueueForRrst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Detail Fro Restaurant'),
      ),
    );
  }
}
