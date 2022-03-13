import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';

import 'package:tronic_ballot/auth/SignUp_SignIn/authHome.dart';
import 'package:tronic_ballot/screen/ConductorScreens/conductorScreen/conductorScreen.dart';
import 'package:tronic_ballot/auth/otp/phoneNoAuth.dart';
import 'package:tronic_ballot/screen/VoterScreens/voterAuthScreen.dart';
import 'package:tronic_ballot/screen/test.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/screen/ConductorScreens/createScreen.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:url_launcher/url_launcher.dart';

BuildContext c;

class StartingScreen extends StatefulWidget {
  static const routeName = "stscr";

  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  bool _isLoading = false;

  final VotersDatabaseService votersDatabaseService =
      new VotersDatabaseService();
  final ConductorsDatabaseService databaseService =
      new ConductorsDatabaseService();
  final uID = ConductorsDatabaseService().uID.toString();

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.pathSegments[0], arguments: {
          "id": "${deepLink.pathSegments[1]}",
          "pass": "${deepLink.pathSegments[2]}"
        });
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.pathSegments[0], arguments: {
        "id": "${deepLink.pathSegments[1]}",
        "pass": "${deepLink.pathSegments[2]}"
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DL().initDynamicLinks();
    c = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "Tronic Ballot",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthHome()));
                });
              })
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, ConductorScreen.routeName);
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                            height: MediaQuery.of(context).size.height * .4,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .35,
                                  child: Image.asset(
                                    'img/conductor.jpg',
                                    scale: 3,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  child: Text('Conductor',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ],
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, BallotAuthScreen.routeName);
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                            height: MediaQuery.of(context).size.height * .4,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .35,
                                  child: Image.asset(
                                    'img/voter.jpg',
                                    scale: 3,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  child: Text('Voter',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ],
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  // MaterialButton(
                  //   onPressed: () => Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => TestDialog())),
                  //   child: Text("Test"),
                  // )
                ],
              ),
            ),
    );
  }
}

class DL {
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        Navigator.pushNamed(c, deepLink.pathSegments[0], arguments: {
          "id": "${deepLink.pathSegments[1]}",
          "pass": "${deepLink.pathSegments[2]}"
        });
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(c, deepLink.pathSegments[0], arguments: {
        "id": "${deepLink.pathSegments[1]}",
        "pass": "${deepLink.pathSegments[2]}"
      });
    }
  }

  Future createDynamicLink(id, pass) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://tronicballot.page.link',
      link: Uri.parse(
          'https://tronicballot.page.link/ballotAuthScreen/$id/$pass'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.tronic_ballot',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
    );

    Uri url;

    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    url = shortLink.shortUrl;
    String dynamicLink = url.toString();
    return dynamicLink;
  }
}
