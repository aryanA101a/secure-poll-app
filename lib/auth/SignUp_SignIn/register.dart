import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:tronic_ballot/screen/homeScreen.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String orgName;
  String phnNum;
  String zipCode;
  String countryValue;
  String stateValue;
  String cityValue;
  final VotersDatabaseService votersDatabaseService =
      new VotersDatabaseService();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                      textFormField(
                        context,
                        borderWidth: 0,
                        hintText: "Zip Code",
                        validator: (val) =>
                            val.isEmpty ? "Enter Zip Code" : null,
                        onChanged: (val) {
                          zipCode = val;
                        },
                      ),
                      textFormField(
                        context,
                        borderWidth: 0,
                        hintText: "Organization Name",
                        validator: (val) =>
                            val.isEmpty ? "Enter Organization Name" : null,
                        onChanged: (val) {
                          orgName = val;
                        },
                      ),
                      textFormField(
                        context,
                        borderWidth: 0,
                        hintText: "Phone Number",
                        validator: (val) =>
                            val.isEmpty ? "Enter Phone Number" : null,
                        onChanged: (val) {
                          phnNum = val;
                        },
                      ),
                      textFormField(
                        context,
                        hintText: "Email",
                        controller: _emailController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      textFormField(context,
                          hintText: "Password", controller: _passwordController,
                          validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }, obscureText: true),
                      Builder(
                        builder: (context) => button(context, text: "Register",
                            onBtnPress: () async {
                          if (countryValue == null ||
                              stateValue == null ||
                              cityValue == null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Select your Country, State and City"),
                            ));
                          } else {
                            if (_formKey.currentState.validate()) {
                              _registerAccount(context);
                            }
                          }
                        }, hMargin: 0, vMargin: 10),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _registerAccount(BuildContext c) async {
    Map<String, String> registrationData = {
      "Country": countryValue,
      "State": stateValue,
      "City": cityValue,
      "Zip Code": zipCode,
      "Organization Name": orgName,
      "Phone Number": phnNum,
    };

    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) async {
        final uid = (FirebaseAuth.instance.currentUser).uid;

        await votersDatabaseService
            .addVoterPollAndRegistrationData(
                registrationData, value.user.uid.toString())
            .then((value) {
          Navigator.of(context).pushReplacementNamed(StartingScreen.routeName);
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
