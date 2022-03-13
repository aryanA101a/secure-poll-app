import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class ConductorsDatabaseService {
  // Future<String> getCurrentUID() async {
  //   return (await FirebaseAuth.instance.currentUser).uid;
  // }

  String get uID {
    try {
      final uid = (FirebaseAuth.instance.currentUser).uid;
      return uid;
    } catch (e) {
      return "null";
    }
  }

  final fireInstance = FirebaseFirestore.instance;
  Future<void> addConductorData1(Map pollData1, String pollId) async {
    await fireInstance.collection("Conductors").doc(pollId).set(pollData1);
  }

  Future<void> addConductorPollData2(
      Map pollData2, String pollId, int count) async {
    await fireInstance
        .collection("Conductors")
        .doc(pollId)
        .collection("ballotQuestion")
        .doc(count.toString())
        .set(pollData2);
  }

  Future<void> configurePollStats(String pollId, String option) async {
    await fireInstance.runTransaction((transaction) async {
      DocumentReference postRef =
          fireInstance.collection('Conductors').doc(pollId);
      DocumentSnapshot snapshot = await transaction.get(postRef);
      int pollCount = snapshot.data()[option] + 1;
      transaction.update(postRef, {option: pollCount});
    });
  }

  Future<void> configureSurveyStats(
      {String id, String option, int docCount}) async {
    await fireInstance.runTransaction((transaction) async {
      DocumentReference postRef = fireInstance
          .collection('Conductors')
          .doc(id)
          .collection("ballotQuestion")
          .doc(docCount.toString());
      DocumentSnapshot snapshot = await transaction.get(postRef);
      int pollCount = snapshot.data()[option] + 1;

      transaction.update(postRef, {option: pollCount});
    });
  }

  Future updateData({elementCount, List dataList, List controllers, id}) async {
    int m = 0;
    while (m < elementCount) {
      if (controllers[m] != dataList[m]) {
        if (m == 0 || (m % 5) == 0) {
          fireInstance
              .collection("Conductors")
              .doc(id)
              .collection("ballotQuestion")
              .doc(((m ~/ 5) + 1).toString())
              .update({"question": controllers[m].text});
        } else {
          fireInstance
              .collection("Conductors")
              .doc(id)
              .collection("ballotQuestion")
              .doc(((m ~/ 5) + 1).toString())
              .update({"option${m % 5}": controllers[m].text});
        }
      }
      print(m);
      ++m;
    }
  }

  getSnapshot(dataType) async {
    return await fireInstance
        .collection("Conductors")
        .where("UID", isEqualTo: uID)
        .where("DataType", isEqualTo: dataType)
        .snapshots();
  }

  getPollSnapshot2(id) async {
    return fireInstance
        .collection("Conductors")
        .doc(id)
        .collection("ballotQuestion")
        .snapshots();
  }

  deletePoll(String jobId) async {
    await fireInstance
        .collection('Conductors')
        .doc(jobId)
        .delete()
        .then((value) async {
      await fireInstance
          .collection('Conductors')
          .doc(jobId)
          .collection('ballotQuestion')
          .doc("1")
          .delete();
    });
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      String imageLocation = 'images/$fileName.jpg';

      // Upload image to firebase.
      await firebase_storage.FirebaseStorage.instance
          .ref(imageLocation)
          .putFile(imageFile);

      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(imageLocation)
          .getDownloadURL();
      print(downloadURL);
      return downloadURL;
    } on FirebaseException catch (e) {
      print("BalleBalle${e.message}");
    }
    // Make random image name.
  }
}
