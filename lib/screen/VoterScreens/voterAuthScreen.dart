import 'package:tronic_ballot/auth/otp/phoneNoAuth.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/screen/VoterScreens/pollDisplay(to%20be%20deleted).dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:tronic_ballot/auth/fingerprint/fingerprintAuthScreen.dart';
import 'package:tronic_ballot/auth/face_recognition/faceRecogHome.dart';
import 'package:tronic_ballot/screen/VoterScreens/voterDisplay.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

String ballotId;

class BallotAuthScreen extends StatefulWidget {
  static const routeName = 'ballotAuthScreen';
  @override
  _BallotAuthScreenState createState() => _BallotAuthScreenState();
}

class _BallotAuthScreenState extends State<BallotAuthScreen> {
  final uID = ConductorsDatabaseService().uID.toString();
  final _formKey = GlobalKey<FormState>();
  String password;
  ConductorsDatabaseService databaseService = new ConductorsDatabaseService();
  VotersDatabaseService votersDatabaseService = new VotersDatabaseService();

  Future<void> checkBallot() async {
    final rVP =
        await FirebaseFirestore.instance.collection("Voters").doc(uID).get();
    final List pollsAttended = await rVP.data()["pollsAttended"];
    final List surveysAttended = await rVP.data()["surveysAttended"];
    final authCheck = await FirebaseFirestore.instance
        .collection("Conductors")
        .doc(ballotId)
        .get();
    if (authCheck.data() != null) {
      if (authCheck.data()["Data"]["id"] == ballotId &&
          authCheck.data()["Data"]["pass"] == password) {
        print("right");

        if (pollsAttended.contains(ballotId) ||
            surveysAttended.contains(ballotId)) {
          Navigator.pop(context);
        } else {
          print(rVP.data()["BallotsAttended"]);
          if (authCheck.data()["Data"]["fpSwitch"]) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FingerprintAuthScreen(
                      ballotId,
                      authCheck.data()["Data"]["frSwitch"],
                      authCheck.data()["Data"]["otpSwitch"]),
                ));
          } else if (authCheck.data()["Data"]["frSwitch"]) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                      authCheck.data()["Data"]["otpSwitch"], ballotId),
                ));
          } else if (authCheck.data()["Data"]["otpSwitch"]) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PhoneNoAuth(ballotId),
                ));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VoterDisplay(
                    ballotId,
                  ),
                ));
          }
        }
      } else {
        print("Wrong ID or Password!");
      }
    } else {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
                title: new Text(
                  "Alert",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: new Text("This event has been closed!!!"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map zuk = ModalRoute.of(context).settings.arguments == null
        ? {"id": "", "pass": ""}
        : ModalRoute.of(context).settings.arguments;
    if (zuk['id'] != '' && zuk['pass'] != '') {
      ballotId = zuk['id'];
      password = zuk['pass'];
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Vote',
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              textFormField(
                context,
                hintText: "ID",
                validator: (val) => val.isEmpty ? "Enter Ballot Id" : null,
                onChanged: (val) {
                  ballotId = val;
                },
                initialValue: zuk['id'],
              ),
              textFormField(
                context,
                hintText: "Password",
                validator: (val) => val.isEmpty ? "Enter Password" : null,
                onChanged: (val) {
                  password = val;
                },
                initialValue: zuk['pass'],
              ),
              Spacer(),
              button(
                context,
                text: "Next",
                radius: 12,
                onBtnPress: () {
                  checkBallot();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
