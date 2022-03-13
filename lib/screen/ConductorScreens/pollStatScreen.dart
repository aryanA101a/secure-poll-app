// import 'package:flutter/material.dart';
// import 'package:tronic_ballot/db/conductorDb.dart';

// class PollStatScreen extends StatefulWidget {
//   final pollId;

//   PollStatScreen(this.pollId);

//   @override
//   _PollStatScreenState createState() => _PollStatScreenState();
// }

// class _PollStatScreenState extends State<PollStatScreen> {
//   ConductorsDatabaseService databaseService = new ConductorsDatabaseService();
//   dynamic statsData;
//   Future retrieveStatData() {
//     databaseService.getPollSnapshot2(widget.pollId).then((value) {
//       statsData = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FutureBuilder(
//       future: retrieveStatData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           Center(
//             child: Container(
//                 child: StreamBuilder(
//               stream: statsData,
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Something went wrong');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Text("Loading");
//                 }
//                 return snapshot.data == null
//                     ? Center(
//                         child: Container(
//                           child: Text("Empty"),
//                         ),
//                       )
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                               "OptionOne: ${snapshot.data.data()['optionOne'].toString()}",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 25)),
//                           Text(
//                               "OptionTwo: ${snapshot.data.data()['optionTwo'].toString()}",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 25)),
//                           Text(
//                               "OptionThree: ${snapshot.data.data()['optionThree'].toString()}",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 25)),
//                           Text(
//                               "OptionFour: ${snapshot.data.data()['optionFour'].toString()}",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 25)),
//                         ],
//                       );
//               },
//             )),
//           );
//         } else {
//           Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return Center(
//           child: Text("No Data"),
//         );
//       },
//     ));
//   }
// }

 