import 'package:flutter/material.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/services/database.dart';
class CreateGroup extends StatefulWidget {
  final User user;
  final List<String> selectedUids;
  CreateGroup({this.user,this.selectedUids});
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  Database db = Database();
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Group'
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,15.0,0,0),
                      child: RawMaterialButton(
                        onPressed: () {},
                        fillColor: Colors.blue,
                        child: Icon(
                          Icons.camera_alt,
                          size: 28.0,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(13.0),
                        shape: CircleBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        child: TextFormField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                          cursorColor: Colors.blue,
                          decoration: new InputDecoration(
                              contentPadding:
                              EdgeInsets.only(left: 8,top: 11, right: 15),
                              hintText: "Group Name"),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Text(
                    "Members: "+widget.selectedUids.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}

