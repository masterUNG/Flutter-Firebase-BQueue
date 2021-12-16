import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:intl/intl.dart';

class DetailQueueForUser extends StatefulWidget {
  final QueueModel queueModel;
  final int sumQueue;
  const DetailQueueForUser(
      {Key key, @required this.queueModel, @required this.sumQueue})
      : super(key: key);

  @override
  _DetailQueueForUserState createState() => _DetailQueueForUserState();
}

class _DetailQueueForUserState extends State<DetailQueueForUser> {
  QueueModel queueModel;
  int sumQueue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.queueModel = widget.queueModel;
    this.sumQueue = widget.sumQueue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail List'),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 25),
              width: 350,
              height: 350,
              child: Card(
                // color: Colors.grey,
                child: Column(
                  children: [
                    Container(
                      // color: Colors.yellow,
                      height: 100,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: ClipOval(
                                child: Image.network(
                                  queueModel.urlImageRest,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.48,
                                      margin: EdgeInsets.only(top: 5),
                                      child:
                                          Text('ร้าน ${queueModel.nameRest}'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.48,
                                        margin: EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Text(
                                            'ที่อยู่ ......................')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 15),
                              height: 90,
                              width: MediaQuery.of(context).size.width * 0.2,
                              // color: Colors.black,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'กำลังรอคิว',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                    divider(),
                    Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/clock.png'),
                          divider(),
                          divider(),
                          divider(),
                          Text(
                            'คิวที่ ${queueModel.queueAmount}',
                            style: TextStyle(fontSize: 30),
                          )
                        ],
                      ),
                    ),
                    divider(),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: Column(
                            children: [
                              Text(changeDateToString(queueModel.time)),
                              Text('วันที่จอง'),
                            ],
                          )),
                          divider(),
                          divider(),
                          Container(
                              child: Column(
                            children: [
                              Text(changeTimeToString(queueModel.time)),
                              Text('เวลาที่จอง'),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Text('SumQueue ===>>> $sumQueue'),
        ],
      ),
    );
  }

  String changeTimeToString(Timestamp time) {
    DateFormat timeFormat = new DateFormat.Hms();
    String timeStr = timeFormat.format(time.toDate());
    return timeStr;
  }

  String changeDateToString(Timestamp time) {
    DateFormat dateFormat = new DateFormat.yMd();
    String dateStr = dateFormat.format(time.toDate());
    return dateStr;
  }

  Divider divider() {
    return Divider(
      height: 15,
      thickness: 1.5,
      indent: 15,
      endIndent: 15,
      color: Colors.black12,
    );
  }
}
