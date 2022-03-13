import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/voterDb.dart';
import 'package:tronic_ballot/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final Map metadata;
  final String dataType;
  final id;
  final int count;
  AddQuestion({this.dataType, this.id, this.count, this.metadata});
  static const routeName = "addQuestion";
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String question, option1, option2, option3, option4;
  bool _isLoading = false;
  ConductorsDatabaseService databaseService = new ConductorsDatabaseService();
  VotersDatabaseService votersDatabaseService = new VotersDatabaseService();

  Future<void> uploadData() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        Map<String, dynamic> dataMap = {
          "option1": option1,
          "option2": option2,
          "option3": option3,
          "option4": option4,
          "question": question,
          "stats1": 0,
          "stats2": 0,
          "stats3": 0,
          "stats4": 0,
        };

        widget.count == 1
            ? await databaseService
                .addConductorData1(widget.metadata, widget.id)
                .then((value) async {
                await databaseService
                    .addConductorPollData2(dataMap, widget.id, widget.count)
                    .then((value) async {
                  if (widget.count == 1) {
                    // await votersDatabaseService.count(widget.dataType);
                  }

                  setState(() {
                    _isLoading = false;
                    Navigator.pop(context);
                  });
                });
              })
            : await databaseService
                .addConductorPollData2(dataMap, widget.id, widget.count)
                .then((value) async {
                if (widget.count == 1) {
                  await votersDatabaseService.count(widget.dataType);
                }

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
          "Fill Data",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: height * 1,
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFormField(
                        context,
                        hintText: "Question",
                        validator: (val) =>
                            val.isEmpty ? "Enter Question" : null,
                        onChanged: (val) {
                          question = val;
                        },
                      ),
                      textFormField(
                        context,
                        hintText: "Option One",
                        validator: (val) =>
                            val.isEmpty ? "Enter Option One" : null,
                        onChanged: (val) {
                          option1 = val;
                        },
                      ),
                      textFormField(
                        context,
                        hintText: "Option Two",
                        validator: (val) =>
                            val.isEmpty ? "Enter Option Two" : null,
                        onChanged: (val) {
                          option2 = val;
                        },
                      ),
                      textFormField(
                        context,
                        hintText: "Option Three",
                        validator: (val) =>
                            val.isEmpty ? "Enter Option Three" : null,
                        onChanged: (val) {
                          option3 = val;
                        },
                      ),
                      textFormField(
                        context,
                        hintText: "Option Four",
                        validator: (val) =>
                            val.isEmpty ? "Enter Option Four" : null,
                        onChanged: (val) {
                          option4 = val;
                        },
                      ),
                      Spacer(),
                      widget.dataType == "poll"
                          ? Builder(
                              builder: (context) => button(
                                    context,
                                    radius: 12,
                                    text: "Submit",
                                    onBtnPress: () async {
                                      uploadData();
                                    },
                                  ))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                button(
                                  context,
                                  radius: 12,
                                  width: 0.45,
                                  text: "Add Question",
                                  onBtnPress: () async {
                                    int count = widget.count;
                                    uploadData().then((value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddQuestion(
                                                dataType: widget.dataType,
                                                id: widget.id,
                                                count: ++count))));
                                  },
                                ),
                                button(
                                  context,
                                  width: 0.45,
                                  radius: 12,
                                  text: "Submit",
                                  onBtnPress: () async {
                                    uploadData();
                                  },
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
