import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tronic_ballot/db/conductorDb.dart';
import 'package:tronic_ballot/screen/ConductorScreens/statScreen.dart';
import 'package:tronic_ballot/screen/editScreen.dart';

class PopUpMenu extends StatelessWidget {
  final id;
  final dynamicLink;
  PopUpMenu(this.id, this.dynamicLink);
  ConductorsDatabaseService databaseService = new ConductorsDatabaseService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton(
        padding: EdgeInsets.all(0),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (value) {
          switch (value) {
            case "share":
              {
                dynamicLink == null ? null : print("hurray");
                Clipboard.setData(new ClipboardData(text: dynamicLink))
                    .then((_) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Share Link copied to clipboard"),
                  ));
                });
              }
              break;
            case "delete":
              {
                databaseService.deletePoll(id);
              }
              break;
            case "edit":
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditScreen(id)));
              }
              break;
            case "stats":
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StatScreen(id)));
              }
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
              value: "stats",
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.poll_outlined,
                      color: Colors.pink,
                      size: 30,
                    ),
                  ),
                  Text("Stats", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              )),
          PopupMenuItem(
            child: PopupMenuDivider(),
            height: 0,
          ),
          PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                  Text("Edit", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              )),
          PopupMenuItem(
            child: PopupMenuDivider(),
            height: 0,
          ),
          PopupMenuItem(
              value: "share",
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.share,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  Text("Share", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              )),
          PopupMenuItem(
            child: PopupMenuDivider(),
            height: 0,
          ),
          PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  Text("Delete", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ))
        ],
        child: Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}
