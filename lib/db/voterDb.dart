import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class VotersDatabaseService {
  final uId = ConductorsDatabaseService().uID.toString();
  Future<void> addVoterPollAndRegistrationData(
      Map voterData, String uId) async {
    await FirebaseFirestore.instance.collection("Voters").doc(uId).set({
      "pollsAttended": [],
      "surveysAttended": [],
      "pollsConducted": 0,
      "surveysConducted": 0,
      "RegistrationData": voterData
    });
  }

  Future<void> addVoterFingerprintData(dynamic fingerprintData) async {
    await FirebaseFirestore.instance
        .collection("Voters")
        .doc(uId)
        .update({"Fingerprint": fingerprintData});
  }

  // Future<void> addVoterFaceData(dynamic fingerprintData) async {
  //   await FirebaseFirestore.instance
  //       .collection("Voters")
  //       .doc(uId)
  //       .update({"Fingerprint": fingerprintData});
  // }
  Future uploadFaceImageToFirebase(File imageFile, String name) async {
    try {
      // String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      String imageLocation = 'faceAuthentication/$uId/$name.jpg';

      // Upload image to firebase.
      await firebase_storage.FirebaseStorage.instance
          .ref(imageLocation)
          .putFile(imageFile);

      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(imageLocation)
          .getDownloadURL()
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("Voters")
            .doc(uId)
            .update({"FaceAuthenticationData": value});
        return;
      });
      print(downloadURL);
    } on FirebaseException catch (e) {
      print("BalleBalle${e.message}");
    }
    // Make random image name.
  }

  Future<dynamic> fingerprintData() async {
    final instance =
        await FirebaseFirestore.instance.collection("Voters").doc(uId).get();
    return instance.data();
  }

  Future<void> updateVoterEntryRegister(dynamic obj, String dataType) async {
    await FirebaseFirestore.instance
        .collection("Voters")
        .doc(uId)
        .update({"${dataType}Attended": FieldValue.arrayUnion(obj)});
  }

  Future<dynamic> checkFaceAuthSignUpStatus() async {
    final instance =
        await FirebaseFirestore.instance.collection("Voters").doc(uId).get();
    return instance.data();
  }

  Future<QuerySnapshot> getDisplayData(String id) async {
    return await FirebaseFirestore.instance
        .collection("Conductors")
        .doc(id)
        .collection("ballotQuestion")
        .get();
  }

  Future count(String dataType) async {
    final count = await FirebaseFirestore.instance
        .collection("Voters")
        .doc(uId)
        .get()
        .then((value) {
      return value.data()["${dataType}sConducted"];
    });
    await FirebaseFirestore.instance
        .collection("Voters")
        .doc(uId)
        .update({"${dataType}sConducted": count + 1});
  }
}
