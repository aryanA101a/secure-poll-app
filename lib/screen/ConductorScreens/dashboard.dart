import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/db/voterDb.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "/dashboard";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final uId = ConductorsDatabaseService().uID;
  VotersDatabaseService votersDatabaseService = new VotersDatabaseService();
  ConductorsDatabaseService databaseService = new ConductorsDatabaseService();
  Future retrievePollCount() async {
    await FirebaseFirestore.instance
        .collection("Voters")
        .doc(uId)
        .get()
        .then((value) {
      pollCount = value.data()["pollsConducted"].toString();
      surveyCount = value.data()["surveysConducted"].toString();
    });
  }

  String pollCount = '', surveyCount = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: retrievePollCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 30, left: 10),
                    child: Text(
                      'DASHBOARD',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * .15,
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Icon(
                                    Icons.poll,
                                    color: Colors.white,
                                  )),
                              Text(
                                'Polls Conducted: $pollCount',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                    color: Color(0xFFf84e5f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * .15,
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Icon(
                                    Icons.poll,
                                    color: Colors.white,
                                  )),
                              Text(
                                'Surveys Conducted: $surveyCount',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                    color: Color(0xFFf84e5f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * .15,
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: Colors.white,
                                  )),
                              Text(
                                'Subscription',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                    color: Color(0xFFfebe30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Text("Loading..."),
          );
        },
      ),
    );
  }
}
