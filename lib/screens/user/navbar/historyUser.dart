import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/screens/listHistoryForUser.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/screens/listQueueForUser.dart';

class HistoryUser extends StatefulWidget {
  @override
  _HistoryUserState createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(30),
                  //     bottomRight: Radius.circular(30)),
                  color: Colors.red,
                ),
                child: TabBar(
                  indicatorColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(
                        Icons.description_sharp,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.history_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListQueueUser(),
                    ListHistoryUser(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
