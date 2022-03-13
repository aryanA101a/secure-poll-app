import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:random_string/random_string.dart';
import 'package:tronic_ballot/screen/VoterScreens/voterDisplay.dart';
import 'package:tronic_ballot/screen/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

import 'package:velocity_x/velocity_x.dart';

class PhoneNoAuth extends StatefulWidget {
  final id;
  PhoneNoAuth(this.id);
  static const routeName = "stscrww";

  @override
  _PhoneNoAuthState createState() => _PhoneNoAuthState();
}

class _PhoneNoAuthState extends State<PhoneNoAuth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  bool timer = false;
  String phoneNo, enteredOTP;
  

  sendOtp() {
    
    if (_formKey.currentState.validate()) {
      var genOtp = randomNumeric(6);
      final otp = genOtp;
      print(otp);
      verifyOTP() {
        if (_formKey.currentState.validate()) {
          if (enteredOTP == otp) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VoterDisplay(widget.id),
                ));
          }
        }
      }

      if (timer == false) {
        setState(() {
          timer = true;
        });
        Timer(Duration(seconds: 60), () {
          setState(() {
            timer = false;
          });
        });
        http
            .get(
                "https://www.fast2sms.com/dev/bulkV2?authorization=AmSlcLF07rGnWqkQJfN2T3d4IZ6Xae9CbMDzwts1VYgK5hxjR86ow0SnWdZuKTzxpXALEJgyjtYCQhUO&route=s&sender_id=CHKSMS&message=2&variables_values=$otp%7C&flash=0&numbers=$phoneNo")
            .then((value) {
          print(value.body);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Dialog(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    height: MediaQuery.of(context).size.height * .32,
                    width: MediaQuery.of(context).size.width * .85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'OTP Verification',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Form(
                          key: _formKey2,
                          child: textFormField(
                            context,
                            keyboardType: TextInputType.number,
                            hintText: "OTP",
                            hMargin: 50,
                            validator: (val) =>
                                val.isEmpty ? "Enter OTP" : null,
                            onChanged: (val) {
                              enteredOTP = val;
                            },
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Text('Okay',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.5)),
                          color: Color(0xFF2B6CB0),
                          onPressed: verifyOTP,
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: _formKey,
            child: textFormField(
              context,
              hintText: "Phone Number",
              vMargin: 50,
              hMargin: 8,
              validator: (val) => val.isEmpty ? "Enter Phone Number" : null,
              onChanged: (val) {
                phoneNo = val;
              },
            ),
          ),
          // Container(
          //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          //     child: VxTextField(
          //       hint: "Phone Number",
          //       borderType: VxTextFieldBorderType.roundLine,
          //       keyboardType: TextInputType.phone,
          //       onChanged: (val) {
          //         phoneNo = val;
          //       },
          //     )),
          Expanded(
            child: Container(
              child: Image.asset(
                'img/secure.png',
                scale: 2,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              height: MediaQuery.of(context).size.height * 0.08,
              width: double.infinity,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Text('Sign Up with OTP',
                    style: TextStyle(color: Colors.white, fontSize: 17.5)),
                color: Color(0xFF2B6CB0),
                onPressed: sendOtp,
              )),
        ],
      ),
    );
  }
}
