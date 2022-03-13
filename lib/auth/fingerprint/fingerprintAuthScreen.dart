import 'package:tronic_ballot/auth/otp/phoneNoAuth.dart';
import 'package:tronic_ballot/screen/VoterScreens/pollDisplay(to%20be%20deleted).dart';
import 'package:tronic_ballot/screen/VoterScreens/voterDisplay.dart';
import 'package:tronic_ballot/screen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tronic_ballot/auth/face_recognition/faceRecogHome.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class FingerprintAuthScreen extends StatefulWidget {
  final frSwitch;
  final otpSwitch;
  final pollId;
  FingerprintAuthScreen(this.pollId, this.frSwitch, this.otpSwitch);

  @override
  _FingerprintAuthScreenState createState() => _FingerprintAuthScreenState();
}

class _FingerprintAuthScreenState extends State<FingerprintAuthScreen> {
  bool capture = false;
  var future;
  dynamic fingerprintData;
  bool _isLoading ;
  bool fingerprintDataCheck;
  dynamic response;
  VotersDatabaseService votersDatabaseService = new VotersDatabaseService();
  static const platform = const MethodChannel('flutter.native/helper');
  String _responseFromNativeCode = 'Waiting for Response...';
  Future<void> responseFromNativeCode(String button) async {
    // String response = "";

    try {
      final dynamic result =
          await platform.invokeMethod(button, fingerprintData).then((value) {
        print("oooooooooooooooooooooooooo$value");
        setState(() {
          response = value;
        });
      });
      // print(result);
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
  }

  signUp(context) async {
    await responseFromNativeCode("PassData").then((value) {
      response != null
          ? votersDatabaseService
              .addVoterFingerprintData(response)
              .then((value) {
              setState(() {
                _isLoading = true;
              });
              votersDatabaseService.fingerprintData().then((value) {
                setState(() {
                  response = null;
                  if (value["Fingerprint"] != null) {
                    fingerprintData = value["Fingerprint"];
                    fingerprintDataCheck = true;
                  }
                  _isLoading = false;
                });
              });
            })
          : Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Add your fingerprint first!"),
            ));
    });
  }

  signIn(context) {
    print("1:$response");

    response != null
        ? responseFromNativeCode("UnInit_PassMatchData").then((value) {
            print("2:$response");
            response >= 96
                ? widget.frSwitch
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(widget.otpSwitch, widget.pollId),
                        ))
                    : widget.otpSwitch
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneNoAuth(widget.pollId),
                            ))
                        : Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VoterDisplay(widget.pollId),
                            ))
                : Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Fingerprint not matched!"),
                  ));
          })
        : Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Add your fingerprint first!"),
          ));
  }

  Future initData() async {
    await votersDatabaseService.fingerprintData().then((value) {
     if (value["Fingerprint"] != null) {
          fingerprintData = value["Fingerprint"];
          fingerprintDataCheck = true;
        } else {
          fingerprintDataCheck = false;
        }

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
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return fingerprintDataCheck
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        child: Icon(
                          Icons.fingerprint,
                          size: 175,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          // print(
                          //     "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
                          responseFromNativeCode("Match").then((value) {
                            print(
                                "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
                          });
                          // setState(() {
                          //   capture = true;
                          //   print(capture);
                          // });
                        },
                      ),
                      Builder(
                        builder: (context) => button(
                          context,
                          text: "Next",
                          radius: 12,
                          hMargin: 10,
                          onBtnPress: () {
                            signIn(context);
                          },
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        child: Icon(
                          Icons.fingerprint,
                          size: 175,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          responseFromNativeCode("Initialize_Capture");
                        },
                      ),
                      Builder(
                          builder: (context) => button(context,
                                  text: "Sign Up",
                                  radius: 12,
                                  hMargin: 10, onBtnPress: () {
                                signUp(context);
                              }))
                    ],
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
