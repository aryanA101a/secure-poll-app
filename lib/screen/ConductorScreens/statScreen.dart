import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class StatScreen extends StatefulWidget {
  final id;
  StatScreen(this.id);
  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  bool _isLoading = true;
  QuerySnapshot questionSnapshot;
  VotersDatabaseService votersDatabaseService = VotersDatabaseService();
  Future initData() async {
    await votersDatabaseService
        .getDisplayData(widget.id)
        .then((QuerySnapshot querySnapshot) {
      questionSnapshot = querySnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: FutureBuilder(
        
        future: initData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              margin: EdgeInsets.all(10),
              child: ListView.builder(

                  itemCount: questionSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    return questionDisplayStatsTile(
                      context,
                      question: questionSnapshot.docs[index].data()["question"],
                      optionOne: questionSnapshot.docs[index].data()["option1"],
                      optionTwo: questionSnapshot.docs[index].data()["option2"],
                      optionThree:
                          questionSnapshot.docs[index].data()["option3"],
                      optionFour:
                          questionSnapshot.docs[index].data()["option4"],
                      statValueOne:
                          questionSnapshot.docs[index].data()["stats1"],
                      statValueTwo:
                          questionSnapshot.docs[index].data()["stats2"],
                      statValueThree:
                          questionSnapshot.docs[index].data()["stats3"],
                      statValueFour:
                          questionSnapshot.docs[index].data()["stats4"],
                    );
                  }),
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
