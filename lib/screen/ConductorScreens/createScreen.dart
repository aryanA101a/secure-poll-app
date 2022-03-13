import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:tronic_ballot/screen/ConductorScreens/conductorScreen/conductorScreen.dart';
import 'package:tronic_ballot/screen/ConductorScreens/addQuestionScreen.dart';
import 'package:tronic_ballot/db/conductorDb.dart';

import 'package:tronic_ballot/screen/homeScreen.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class CreateScreen extends StatefulWidget {
  static const routeName = "create";
  String dataType;
  CreateScreen(this.dataType);
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  String imgLink;
  File _image;
  final picker = ImagePicker();

  Future getImage(BuildContext context) async {
    try {
      final pickedFile = await picker
          .getImage(
              source: ImageSource.gallery,
              imageQuality: 50,
              maxHeight: 720,
              maxWidth: 720)
          .then((value) {
        setState(() {
          _isLoading = true;
          if (value != null) {
            _image = File(value.path);
          } else {
            print('No image selected.');
          }
        });
        databaseService.uploadImageToFirebase(_image).then((value) {
          setState(() {
            _isLoading = false;
            imgLink = value;
            print(imgLink);
          });
        });
      });
    } catch (e) {
      print(e.toString());
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }

  final genId = DateTime.now().millisecondsSinceEpoch.toString();
  final _formKey = GlobalKey<FormState>();
  bool _fpSwitch = false;
  bool _frSwitch = false;
  bool _otpSwitch = false;
  String title;
  ConductorsDatabaseService databaseService = new ConductorsDatabaseService();
  VotersDatabaseService votersDatabaseService = new VotersDatabaseService();

  DL dl = new DL();

  bool _isLoading = false;
  String password;
  final uID = ConductorsDatabaseService().uID;

  final _random = new Random();

  var list = [
    '0xFFf84e5f',
    '0xFFfebe30',
    '0xFFac39ff',
    '0xFF68cc45 ',
    '0xFF007aff'
  ];

  Future<void> create() async {
    if (_formKey.currentState.validate()) {
      final id = genId;
      String dynamicLink = await dl.createDynamicLink(id, password);
      var element = list[_random.nextInt(list.length)];

      Map<String, dynamic> dataMap = {
        "Data": {
          "image": imgLink,
          "fpSwitch": _fpSwitch,
          "frSwitch": _frSwitch,
          "otpSwitch": _otpSwitch,
          "pass": password,
          "id": id,
          "title": title,
          "dynamicLink": dynamicLink,
          "tileColor": element
        },
        "DataType": "${widget.dataType}",
        "UID": uID,
      };

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddQuestion(
              dataType: widget.dataType,
              id: id,
              count: 1,
              metadata: dataMap,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "CREATE ${widget.dataType.toUpperCase()}",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Builder(
            builder: (context) => Container(
                  height: height,
                  padding: EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _image != null
                            ? InkWell(
                                onTap: () {
                                  getImage(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  // height: 160.0,
                                  // width: 160.0,
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage:
                                        FileImage(File(_image.path)),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(vertical: 15),
                                height: 160.0,
                                width: 160.0,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    getImage(context).then((value) {
                                      _image != null
                                          ? databaseService
                                              .uploadImageToFirebase(_image)
                                          : null;
                                    }).then((value) {
                                      imgLink = value;
                                      print(imgLink);
                                    });
                                  },
                                  elevation: 2.0,
                                  fillColor: Colors.blue,
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                              ),
                        textFormField(
                          context,
                          hintText: "Title",
                          validator: (val) =>
                              val.isEmpty ? "Enter Title" : null,
                          onChanged: (val) {
                            title = val;
                          },
                          maxLength: 20,
                        ),
                        textFormField(
                          context,
                          hintText: "Password",
                          validator: (val) =>
                              val.isEmpty ? "Enter Password" : null,
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2.5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.fingerprint,
                                      size: 40, color: Colors.blue),
                                  Text('Fingerprint',
                                      style: TextStyle(fontSize: 20)),
                                  Switch(
                                    value: _fpSwitch,
                                    onChanged: (val) {
                                      setState(() {
                                        _fpSwitch = !_fpSwitch;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.face,
                                      size: 40, color: Colors.blue),
                                  Text('Face Recognition',
                                      style: TextStyle(fontSize: 20)),
                                  Switch(
                                    value: _frSwitch,
                                    onChanged: (val) {
                                      setState(() {
                                        _frSwitch = !_frSwitch;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.message_rounded,
                                      size: 40, color: Colors.blue),
                                  Text('One Time Password(OTP)',
                                      style: TextStyle(fontSize: 20)),
                                  Switch(
                                    value: _otpSwitch,
                                    onChanged: (val) {
                                      setState(() {
                                        _otpSwitch = !_otpSwitch;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 2.5, vertical: 5),
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: double.infinity,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text("Next",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19)),
                            color: Color(0xFF2B6CB0),
                            onPressed: _isLoading
                                ? () {}
                                : () {
                                    create();
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
