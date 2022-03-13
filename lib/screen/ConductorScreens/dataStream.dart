import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/screen/ConductorScreens/pollStatScreen.dart';
import 'package:tronic_ballot/widgets/pollAndSurveyTile.dart';
import 'package:tronic_ballot/screen/editScreen.dart';
import 'dart:typed_data';

Widget dataList(Stream dataStream) {
  return Container(
    child: StreamBuilder(
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
        return snapshot.data == null
            ? Center(
                child: Container(
                  child: Text("Empty"),
                ),
              )
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Tile(
                      snapshot.data.documents[index].data()["Data"]["title"],
                      snapshot.data.documents[index].data()["Data"]["id"],
                      snapshot.data.documents[index].data()["Data"]["pass"],
                      snapshot.data.documents[index].data()["Data"]
                          ["dynamicLink"],
                      snapshot.data.documents[index].data()["Data"]
                          ["tileColor"],
                      snapshot.data.documents[index].data()["Data"]["image"]);
                },
              );
      },
    ),
  );
}
