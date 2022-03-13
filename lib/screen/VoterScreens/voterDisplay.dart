import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:tronic_ballot/screen/homeScreen.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class VoterDisplay extends StatefulWidget {
  final id;
  VoterDisplay(this.id);
  @override
  _VoterDisplayState createState() => _VoterDisplayState();
}

class _VoterDisplayState extends State<VoterDisplay> {
  int docCount = 0;
  var future;
  List<int> options;
  int address = 0;
  List<int> _gVal;
  setSelected(int val, int index) {
    setState(() {
      _gVal[index] = val;
    });
  }

  bool _isLoading = false;
  VotersDatabaseService votersDatabaseService = VotersDatabaseService();
  ConductorsDatabaseService conductorsDatabaseService =
      ConductorsDatabaseService();
  QuerySnapshot questionSnapshot;

  submitFunc(context, List options) async {
    if (options.contains(null)) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Attempt All!")));
    } else {
      cases(String option, int docCount) {
        conductorsDatabaseService.configureSurveyStats(
            id: widget.id, option: option, docCount: docCount);
      }

      options.forEach((element) {
        ++docCount;
        cases("stats$element", docCount);
      });
      votersDatabaseService.updateVoterEntryRegister(
          [widget.id], questionSnapshot.docs.length == 1 ? "polls" : "surveys");
      docCount = 0;
      Navigator.pushReplacementNamed(context, StartingScreen.routeName);
    }
  }

  Future initData() async {
    await votersDatabaseService
        .getDisplayData(widget.id)
        .then((QuerySnapshot querySnapshot) {
      questionSnapshot = querySnapshot;

      options = new List(querySnapshot.docs.length);
      _gVal = new List(querySnapshot.docs.length);
    });
  }

  @override
  void initState() {
    future = initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          tooltip: "Submit",
          child: Icon(Icons.arrow_forward),
          onPressed: () {
            submitFunc(context, options);
          },
        ),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: questionSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    return questionDisplayTile(
                      context,
                      question: questionSnapshot.docs[index].data()["question"],
                      radioOnChanged: (value) {
                        setSelected(value, index);
                        options[index] = value;
                        print(options);
                      },
                      gVal: _gVal[index],
                      optionOne: questionSnapshot.docs[index].data()["option1"],
                      optionTwo: questionSnapshot.docs[index].data()["option2"],
                      optionThree:
                          questionSnapshot.docs[index].data()["option3"],
                      optionFour:
                          questionSnapshot.docs[index].data()["option4"],
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

// Widget(BuildContext context){
//   return
// }
