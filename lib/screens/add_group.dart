import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/User.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select group members',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group_add),
        onPressed: () {
          print(selectedUids.toString());
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            var docs = snapshot.data.documents;
            return ListView.builder(
              itemBuilder: (context, index) {
                list.add(SelectListTile(user: docs[index], isSelected: false));
                return widget.user.followers.contains(docs[index]['uid']) ||
                        widget.user.following.contains(docs[index]['uid'])
                    ? Container(
                        color:
                            list[index].isSelected ? Colors.blue : Colors.white,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              list[index].isSelected =
                                  list[index].isSelected ? false : true;
                              list[index].isSelected
                                  ? selectedUids.add(docs[index]['uid'])
                                  : selectedUids.remove(docs[index]['uid']);
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
