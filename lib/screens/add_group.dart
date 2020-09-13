import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/create_group.dart';

class SelectListTile {
  DocumentSnapshot user;
  bool isSelected = false;
  SelectListTile({this.user, this.isSelected});
}

class AddGroup extends StatefulWidget {
  final User user;
  AddGroup({this.user});
  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<String> selectedUids = [];
  List<SelectListTile> list = [];
  var docs;
  @override
  Widget build(BuildContext context) {
    if (!selectedUids.contains(widget.user.uid))
      selectedUids.add(widget.user.uid);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Select group members',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                (selectedUids.length - 1).toString() + " members selected",
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.keyboard_arrow_right),
        onPressed: () {
          if (docs != null)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateGroup(
                          user: widget.user,
                          selectedUids: selectedUids,
                        )));
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            docs = snapshot.hasData ? snapshot.data.documents : null;
            return !snapshot.hasData
                ? SizedBox.shrink()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      list.add(
                          SelectListTile(user: docs[index], isSelected: false));
                      return widget.user.followers
                                  .contains(docs[index]['uid']) ||
                              widget.user.following.contains(docs[index]['uid'])
                          ? Container(
                              color: list[index].isSelected
                                  ? Colors.blue
                                  : Colors.transparent,
                              child: ListTile(
                                trailing: list[index].isSelected
                                    ? Text(
                                        "SELECTED",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.1),
                                      )
                                    : SizedBox.shrink(),
                                onTap: () {
                                  setState(() {
                                    list[index].isSelected =
                                        list[index].isSelected ? false : true;
                                    list[index].isSelected
                                        ? selectedUids.add(docs[index]['uid'])
                                        : selectedUids
                                            .remove(docs[index]['uid']);
                                  });
                                },
                                title: Text(
                                  docs[index]['name'],
                                  style: TextStyle(
                                      color: list[index].isSelected
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(docs[index]['userphoto']),
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                    itemCount: snapshot.data.documents.length,
                  );
          }),
    );
  }
}
