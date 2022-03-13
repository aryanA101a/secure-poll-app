import 'package:flutter/material.dart';
import 'package:tronic_ballot/auth/SignUp_SignIn/register.dart';
import 'package:tronic_ballot/auth/SignUp_SignIn/signIn.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class AuthHome extends StatefulWidget {
  static const routeName = "email_sign";
  @override
  _AuthHomeState createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue[300], Colors.teal[300]])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset("img/vote.png"),
            ),
            button(
              context,
              onBtnPress: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
              text: "Sign In",
              hMargin: 30,
              height: 0.065,
              radius: 8,
              textSize: 20,
              color: Colors.black38,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            button(
              context,
              onBtnPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              text: "Register",
              hMargin: 30,
              height: 0.065,
              radius: 8,
              textSize: 20,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
