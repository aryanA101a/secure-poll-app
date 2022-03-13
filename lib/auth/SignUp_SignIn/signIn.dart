import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/auth/otp/phoneNoAuth.dart';

import 'package:tronic_ballot/screen/homeScreen.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        textFormField(
                          context,
                          borderWidth: 0,
                          hintText: "Email",
                          validator: (val) =>
                              val.isEmpty ? "Enter email address" : null,
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                        textFormField(
                          context,
                          borderWidth: 0,
                          hintText: "Password",
                          validator: (val) =>
                              val.isEmpty ? "Enter password" : null,
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                        Builder(
                          builder: (context) => button(
                            context,
                            text: "Sign In",
                            onBtnPress: () {
                              _signInWithEmailAndPassword(context);
                            },
                            hMargin: 0,
                            vMargin: 10,
                            radius: 8,
                          ),
                        )
                      ],
                    )),
              ));
  }

  void _signInWithEmailAndPassword(BuildContext c) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => StartingScreen(),
          ));
          setState(() {
            _isLoading = false;
          });
        });
      } catch (e) {
        print(e.toString());
        Scaffold.of(c).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    }
  }
}
