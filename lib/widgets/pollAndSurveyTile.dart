import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/widgets/popUpMenu.dart';

class Tile extends StatelessWidget {
  final ConductorsDatabaseService databaseService =
      new ConductorsDatabaseService();
  final String title;
  final String id;
  final String password;
  final String dynamicLink;
  final String tileColor;
  final String imgLink;
  Tile(
      @required this.title,
      @required this.id,
      @required this.password,
      @required this.dynamicLink,
      @required this.tileColor,
      @required this.imgLink);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: MediaQuery.of(context).size.height * .17,
        child: Card(
          color: Color(int.parse(tileColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    imgLink == null
                        ? Container(
                            height: 120.0,
                            width: 120.0,
                            child: Icon(
                              Icons.circle,
                              size: 125,
                              color: Colors.white,
                            ),
                          )
                        : Container(
                            height: 120.0,
                            width: 120.0,
                            child: CachedNetworkImage(
                              imageUrl: imgLink,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              title == null ? "null" : title,
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              "Ballot Id: ${id == null ? "" : id}",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "Password: ${password == null ? "" : password}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopUpMenu(id, dynamicLink),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
