import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tronic_ballot/screen/ConductorScreens/createScreen.dart';
import 'package:tronic_ballot/screen/ConductorScreens/dashboard.dart';
import 'package:tronic_ballot/screen/ConductorScreens/dataStream.dart';
import 'package:tronic_ballot/screen/ConductorScreens/pollStatScreen.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:flutter/material.dart';
import "dart:math";

import 'package:tronic_ballot/screen/ConductorScreens/conductorScreen/pollTab.dart';
import 'package:tronic_ballot/screen/ConductorScreens/conductorScreen/surveyTab.dart';

class ConductorScreen extends StatefulWidget {
  static const routeName = "conductor";

  @override
  _ConductorScreenState createState() => _ConductorScreenState();
}

class _ConductorScreenState extends State<ConductorScreen> {
  

  bool dialVisible = true;
  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),

      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.poll, color: Colors.white),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateScreen("poll")));
          },
          label: 'Poll',
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
        ),
        SpeedDialChild(
          child: Icon(Icons.leaderboard, color: Colors.white),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateScreen("survey")));
          },
          label: 'Survey',
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: buildSpeedDial(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Conduct',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: "Poll",
                  icon: Icon(
                    Icons.poll,
                  ),
                ),
                Tab(
                  text: "Survey",
                  icon: Icon(Icons.leaderboard),
                )
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(''),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.pushNamed(context, DashboardScreen.routeName);
                  },
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xFFf2f2f2),
          body: TabBarView(
            children: [PollTab(), SurveyTab()],
          )
          // Container(margin: EdgeInsets.only(top: 10), child: dataList()),

          ),
    );
  }
}

