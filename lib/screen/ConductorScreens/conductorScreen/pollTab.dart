import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/screen/ConductorScreens/dataStream.dart';

class PollTab extends StatefulWidget {
  @override
  _PollTabState createState() => _PollTabState();
}

class _PollTabState extends State<PollTab> {
  ConductorsDatabaseService databaseService = new ConductorsDatabaseService();
  Stream dataStream;
  Future initData() async {
    await databaseService.getSnapshot("poll").then((val) {
      dataStream = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
              margin: EdgeInsets.only(top: 10), child: dataList(dataStream));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Text("Loading..."),
        );
      },
    );
  }
}
