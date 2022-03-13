// import 'package:flutter/material.dart';
// import 'package:tronic_ballot/db/conductorDb.dart';
// import 'package:tronic_ballot/db/voterDb.dart';
// import 'package:tronic_ballot/screen/homeScreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tronic_ballot/widgets/widgets.dart';

// class PollDisplay extends StatefulWidget {
//   final id;
//   PollDisplay(
//     this.id,
//   );

//   @override
//   _PollDisplayState createState() => _PollDisplayState();
// }

// class _PollDisplayState extends State<PollDisplay> {
//   VotersDatabaseService votersDatabaseService = new VotersDatabaseService();
//   ConductorsDatabaseService databaseService = new ConductorsDatabaseService();
//   bool _isLoading = false;
//   int _gVal = 0;
//   int address = 0;
//   setSelected(int val) {
//     setState(() {
//       _gVal = val;
//     });
//   }

//   String question = '';
//   String optionOne = '';
//   String optionTwo = '';
//   String optionThree = '';
//   String optionFour = '';
//   Future getQuestionData() async {
//     final pollDataFetch = await FirebaseFirestore.instance
//         .collection("Conductors")
//         .doc(widget.id)
//         .collection("ballotQuestion")
//         .doc(widget.id)
//         .get();
//     setState(() {
//       question = pollDataFetch.data()["question"];
//       optionOne = pollDataFetch.data()["option1"];
//       optionTwo = pollDataFetch.data()["option2"];
//       optionThree = pollDataFetch.data()["option3"];
//       optionFour = pollDataFetch.data()["option4"];
//     });
//   }

//   submitFunc(int addr) {
//     cases(String option) {
//       setState(() {
//         _isLoading = true;
//       });

//       databaseService.configurePollStats(widget.id, option).then((value) {
//         setState(() {
//           _isLoading = false;
//         });
//         Navigator.pop(context);
//       });
//     }

//     switch (addr) {
//       case 1:
//         {
//           cases("optionOne");
//         }
//         break;
//       case 2:
//         {
//           cases("optionTwo");
//         }
//         break;
//       case 3:
//         {
//           cases("optionThree");
//         }
//         break;
//       case 4:
//         {
//           cases("optionFour");
//         }
//         break;
//       case 0:
//         {
//           Navigator.pop(context);
//         }
//         break;
//     }
//   }

//   @override
//   void initState() {
//     // votersDatabaseService.updateVoterPollData([widget.pollId], widget.pollId);
//     getQuestionData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//               child: ListView(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(
//                         top: 40, left: 20, right: 20, bottom: 40),
//                     child: Container(
//                       margin:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                       child: Text(
//                         "Q: $question",
//                         style: TextStyle(
//                           fontSize: 25,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Column(
//                       children: [
//                         option(context, radioValue: 1, radioGroupValue: _gVal,
//                             radioOnChanged: (value) {
//                           setSelected(value);
//                           address = value;
//                         }, text: optionOne),
//                         option(context, radioValue: 2, radioGroupValue: _gVal,
//                             radioOnChanged: (value) {
//                           setSelected(value);
//                           address = value;
//                         }, text: optionTwo),
//                         option(context, radioValue: 3, radioGroupValue: _gVal,
//                             radioOnChanged: (value) {
//                           setSelected(value);
//                           address = value;
//                         }, text: optionThree),
//                         option(context, radioValue: 4, radioGroupValue: _gVal,
//                             radioOnChanged: (value) {
//                           setSelected(value);
//                           address = value;
//                         }, text: optionFour),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.1,
//                   ),
//                   button(
//                     context,
//                     text: "Submit",
//                     onBtnPress: () async {
//                       await votersDatabaseService
//                           .updateVoterPollData([widget.id], "polls");
//                       submitFunc(address);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }




