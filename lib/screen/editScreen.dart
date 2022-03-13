import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

int elementCount;
int a = 0;

class EditScreen extends StatefulWidget {
  final String id;
  EditScreen(this.id);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  List dataList;
  List<Map<String, String>> updatedMap;
  List<TextEditingController> controllers;
  int controllerCount = 0;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  VotersDatabaseService votersDatabaseService = VotersDatabaseService();
  ConductorsDatabaseService conductorsDatabaseService =
      ConductorsDatabaseService();
  QuerySnapshot questionSnapshot;
  Future<void> uploadData(BuildContext context) async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });

        await conductorsDatabaseService
            .updateData(
                elementCount: elementCount,
                dataList: dataList,
                controllers: controllers,
                id: widget.id)
            .then((value) {
          setState(() {
            _isLoading = false;
            Navigator.pop(context);
          });
        });
      }
    } catch (e) {
      print(e.toString());
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }

  Future initData() async {
    await votersDatabaseService
        .getDisplayData(widget.id)
        .then((QuerySnapshot querySnapshot) {
      elementCount = (querySnapshot.docs.length * 5);
      questionSnapshot = querySnapshot;
      updatedMap = new List(querySnapshot.docs.length);
      controllers = new List(elementCount);
      dataList = new List(elementCount);

      int b = 0;
      List.generate(questionSnapshot.docs.length, (index) {
        dataList[b++] = (questionSnapshot.docs[index].data()["question"]);
        dataList[b++] = (questionSnapshot.docs[index].data()["option1"]);
        dataList[b++] = (questionSnapshot.docs[index].data()["option2"]);
        dataList[b++] = (questionSnapshot.docs[index].data()["option3"]);
        dataList[b++] = (questionSnapshot.docs[index].data()["option4"]);
      });
      // for (int d = 0; d <= querySnapshot.docs.length - 1; d++) {
      //   dataList[b++] = (questionSnapshot.docs[d].data()["question"]);
      //   dataList[b++] = (questionSnapshot.docs[d].data()["option1"]);
      //   dataList[b++] = (questionSnapshot.docs[d].data()["option2"]);
      //   dataList[b++] = (questionSnapshot.docs[d].data()["option3"]);
      //   dataList[b++] = (questionSnapshot.docs[d].data()["option4"]);
      // }

      // for (int c = 0; c <= elementCount - 1; c++)
      // int c = 0;
      List.generate(elementCount, (index) {
        controllers[index] = TextEditingController(text: dataList[index]);
      });
      // while (c < elementCount) {
      //   controllers[c] = TextEditingController(text: dataList[c]);
      //   ++c;
      // }
    });
  }

  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  void dispose() {
    controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int controllerCount = 0;
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () {
            uploadData(context);
          },
          label: Text("Save"),
          icon: Icon(Icons.save),
        ),
      ),
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
          title: Text("Edit", style: TextStyle(color: Colors.black)),
          elevation: 0,
          backgroundColor: Colors.transparent),
      body: FutureBuilder(
        future: initData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                margin: EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children:
                          List.generate(questionSnapshot.docs.length, (index) {
                        return editQuestionTile(
                          context,
                          controller1: controllers[controllerCount++],
                          controller2: controllers[controllerCount++],
                          controller3: controllers[controllerCount++],
                          controller4: controllers[controllerCount++],
                          controller5: controllers[controllerCount++],
                          // initialQuestion:
                          //     ,
                          // initialOptionOne:
                          // initialOptionTwo:
                          // initialOptionThree:
                          // initialOptionFour:
                        );
                      }),
                    )));
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
