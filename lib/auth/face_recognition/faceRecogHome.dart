import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:random_string/random_string.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:tronic_ballot/auth/face_recognition/sign-in.dart';
// import 'package:tronic_ballot/auth/face_recognition/sign-up.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/auth/otp/phoneNoAuth.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:tronic_ballot/screen/VoterScreens/voterDisplay.dart';
// import 'package:tronic_ballot/widgets/loadingButton.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class MyHomePage extends StatefulWidget {
  final otpSwitch;
  final pollId;
  MyHomePage(this.otpSwitch, this.pollId);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  VotersDatabaseService votersDatabaseService = VotersDatabaseService();
  var sourceImage;
  var queryImage;
  bool _signUpStatus = false;
  String name = "";
  bool _isLoading = true;
  bool _buttonLoading = false;
  File _image;
  final picker = ImagePicker();
  Dio dio = new Dio();
  Future signUp() async {
    try {
      final pickedFile = await picker
          .getImage(
        source: ImageSource.camera,
        imageQuality: 40,
        preferredCameraDevice: CameraDevice.values[0],
      )
          .then((value) async {
        setState(() {
          _buttonLoading = true;
        });

        if (value != null) {
          FormData data = FormData.fromMap({
            "file": await MultipartFile.fromFile(
              value.path,
              filename: randomAlpha(5),
            ),

            // "type": "image/jpg"
          });
          dio
              .post(
                  "https://tronic-ballot.herokuapp.com/v1/image/face_detection",
                  data: data)
              .then((response) {
            print(response.data);
            response.data == "1"
                ? votersDatabaseService
                    .uploadFaceImageToFirebase(File(value.path), name)
                    .then((value) {
                    setState(() {
                      _signUpStatus = true;
                      _buttonLoading = false;
                    });
                  })
                : showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => dialogBox(context,
                            title: "Alert",
                            content: "${response.data} Faces Detected!",
                            btnText: "Okay", onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _buttonLoading = false;
                          });
                        }));
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getSourceImage(url) async {
    if (url != null) {
      final response = await http.get(url);

      // Get the image name
      final imageName = randomAlpha(5);
      // Get the document directory path
      final appDir = await pathProvider.getTemporaryDirectory();

      // This is the saved image path
      // You can use it to display the saved image later.
      final localPath = path.join(appDir.path, imageName);

      // Downloading
      final imageFile = File(localPath);

      await imageFile.writeAsBytes(response.bodyBytes);
      // sourceImage = base64Encode(imageFile.readAsBytesSync());
      // print(base64Encode(imageFile.readAsBytesSync()));
      return imageFile;
    }
  }

  signIn() async {
    try {
      final pickedFile = await picker
          .getImage(
        source: ImageSource.camera,
        // imageQuality: 50,
        preferredCameraDevice: CameraDevice.values[0],
      )
          .then((value) async {
        // var mb = ((await value.readAsBytes()).lengthInBytes) / 1040000;
        // var cSize = double.parse(mb.toStringAsFixed(2)) / 0.4;
        // var percentage = 100 / cSize;
        // File compressedFile =
        //     await FlutterNativeImage.compressImage(value.path);
        // print(((await compressedFile.readAsBytes()).lengthInBytes) / 1040000);
        // var queryImage = base64Encode(File(value.path).readAsBytesSync());
        FormData data = FormData.fromMap({
          "file1": await MultipartFile.fromFile(
            sourceImage.path,
            filename: randomAlpha(5),
          ),
          "file2": await MultipartFile.fromFile(
            value.path,
            filename: randomAlpha(5),
          ),
          // "type": "image/jpg"
        });
        await dio
            .post(
                'https://tronic-ballot.herokuapp.com/v1/image/face_recognition',
                data: data)
            .then((response) {
          if ((response.data).contains('_')) {
            _btnController.reset();

            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => dialogBox(context,
                        title: "Alert",
                        content: (response.data).replaceAll('_', " "),
                        btnText: "Okay", onPressed: () {
                      Navigator.pop(context);
                      // setState(() {});
                    }));
          } else {
            print(response.data);
            if (double.parse(response.data) <= 0.549) {
              _btnController.success();
              Timer(Duration(seconds: 1), () {
                if (widget.otpSwitch) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneNoAuth(widget.pollId),
                      ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => VoterDisplay(widget.pollId)));
                }
              });
            } else {
              _btnController.reset();

              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => dialogBox(context,
                          title: "Alert",
                          content: "Not Recognized",
                          btnText: "Okay", onPressed: () {
                        Navigator.pop(context);
                        // setState(() {});
                      }));
            }
          }
        });
      });
    } catch (e) {
      _btnController.reset();
      print(e.toString());
    }
  }

  Future initData() async {
    await votersDatabaseService.checkFaceAuthSignUpStatus().then((value) {
      if (sourceImage == null) {
        getSourceImage(value["FaceAuthenticationData"]).then((value) {
          sourceImage = value;
        });
      }
      _signUpStatus = value["FaceAuthenticationData"] != null ? true : false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Face Authentication",
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: initData(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          'img/face-recognition.png',
                          scale: 2,
                        ),
                      ),
                      !_signUpStatus
                          // _dataBaseService.checkSignUpStatus()
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: double.infinity,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: _buttonLoading
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      )
                                    : Text("Sign Up",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 19)),
                                color: Color(0xFF2B6CB0),
                                onPressed: _isLoading
                                    ? () {}
                                    : () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) => AlertDialog(
                                                  title: new Text(
                                                    "Enter Your Name",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  content:
                                                      textFormField(context,
                                                          onChanged: (val) {
                                                    name = val;
                                                  }, hintText: "Name"),
                                                  actions: <Widget>[
                                                    // usually buttons at the bottom of the dialog
                                                    new FlatButton(
                                                      child: new Text("Next"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        signUp();
                                                      },
                                                    ),
                                                  ],
                                                ));
                                      },
                              ),
                            )
                          // button(
                          //     context,
                          //     text: "Sign Up",
                          //     hMargin: 10,
                          //     vMargin: 10,
                          //     radius: 8,
                          //     onBtnPress: () {
                          //   showDialog(
                          //       context: context,
                          //       barrierDismissible: true,
                          //       builder: (context) => AlertDialog(
                          //             title: new Text(
                          //               "Enter Your Name",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.bold),
                          //             ),
                          //             content: textFormField(context,
                          //                 onChanged: (val) {
                          //               name = val;
                          //             }, hintText: "Name"),
                          //             actions: <Widget>[
                          //               // usually buttons at the bottom of the dialog
                          //               new FlatButton(
                          //                 child: new Text("Next"),
                          //                 onPressed: () {
                          //                   Navigator.of(context).pop();
                          //                   signUp();
                          //                 },
                          //               ),
                          //             ],
                          //           ));
                          // },
                          //   )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: RoundedLoadingButton(
                                      borderRadius: 8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width,
                                      color: Color(0xFF2B6CB0),
                                      successColor: Color(0xFF2B6CB0),
                                      controller: _btnController,
                                      child: Text("Sign In",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.3)),
                                      onPressed: signIn,
                                    ),
                                  )
                                  // LoadingButton(
                                  //   text: "Sign In",
                                  //   onBtnPress: signIn,
                                  // ),
                                  ,
                                  // button(context,
                                  //     text: "Sign Out",
                                  //     hMargin: 10,
                                  //     vMargin: 5,
                                  //     radius: 8,
                                  //     onBtnPress: () {}),
                                ],
                              ),
                            )
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              }
              return Center(
                child: Text("No Data"),
              );
            }));
  }
}
