import 'package:firebase_auth/firebase_auth.dart';

import 'package:tronic_ballot/auth/SignUp_SignIn/authHome.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/screen/ConductorScreens/conductorScreen/conductorScreen.dart';
import 'package:tronic_ballot/auth/otp/phoneNoAuth.dart';
import 'package:tronic_ballot/screen/ConductorScreens/dashboard.dart';
import 'package:tronic_ballot/screen/VoterScreens/voterDisplay.dart';
import 'package:tronic_ballot/screen/VoterScreens/voterAuthScreen.dart';
import 'package:tronic_ballot/screen/editScreen.dart';
import 'package:tronic_ballot/screen/homeScreen.dart';
import 'package:tronic_ballot/screen/ConductorScreens/addQuestionScreen.dart';
import 'package:tronic_ballot/screen/ConductorScreens/createScreen.dart';


import 'package:tronic_ballot/auth/fingerprint/fingerprintAuthScreen.dart';
import 'package:tronic_ballot/auth/face_recognition/faceRecogHome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tronic_ballot/auth/SignUp_SignIn/register.dart';

String valPhone;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final ConductorsDatabaseService databaseService =
      new ConductorsDatabaseService();
  final uID = ConductorsDatabaseService().uID.toString();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          //  PhoneNoAuth(),
          _auth.currentUser != null ? StartingScreen() : AuthHome(),
      // SurveyDisplay(),

      // FingerprintAuthScreen("weutfu2",false),
      // StartingScreen(),
      // MyHomePage(),
      // valPhone != null && uID !="null"  ? StartingScreen() : PhoneNoAuth(),
      routes: {
        StartingScreen.routeName: (ctx) => StartingScreen(),
        // CreatePoll.routeName: (ctx) => CreatePoll(),
        ConductorScreen.routeName: (ctx) => ConductorScreen(),
        BallotAuthScreen.routeName: (ctx) => BallotAuthScreen(),
        // PhoneNoAuth.routeName: (ctx) => PhoneNoAuth(),
        DashboardScreen.routeName: (ctx) => DashboardScreen(),
      },
    );
  }
}
