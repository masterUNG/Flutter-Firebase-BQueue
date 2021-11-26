import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/user/navbar/screens/listHistoryUser.dart';
import 'package:flutter_application_beng_queue_app/user/navbar/screens/listQueueUser.dart';

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
                child: TabBar(
                  indicatorColor: Colors.redAccent,
                  unselectedLabelColor: Colors.redAccent,
                  labelColor: Colors.redAccent,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.description_sharp),
                    ),
                    Tab(
                      icon: Icon(Icons.history_outlined),
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
