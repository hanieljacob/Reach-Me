import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/models/User.dart';
import 'home.dart';
import 'search.dart';
import 'post.dart';
import 'account.dart';

import '../services/database.dart';

class NotificationsPage extends StatefulWidget {
  final int index;
  NotificationsPage({this.index});
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 3;
  bool firsttime = true;
  List<User> users = [];
  List<User> reqUsers = [];
  Database db = Database();
  void getRequestedUsers(String uid) {
//    db.getUsers(uid).then((value) { setState((){users = value;});});
    db.getRequest(uid).then((value) {
      db.getRequestedUser(value).then((value) => setState(() {
            reqUsers = value;
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.index;
    var user = Provider.of<FirebaseUser>(context);
    if (firsttime) {
      getRequestedUsers(user.uid);
      firsttime = false;
    }
    return _selectedIndex == 3
        ? SafeArea(
            child: Scaffold(
                body: StreamBuilder<Object>(
                  stream: Firestore.instance.collection('Users').document(user.uid).snapshots(),
                  builder: (context, snapshot) {
                    getRequestedUsers(user.uid);
                    return CustomScrollView(slivers: [
              SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        child: ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(reqUsers[index].photoUrl),
                          ),
                          title: Text(reqUsers[index].name),
                          trailing: FlatButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Text('Accept'),
                            onPressed: () {
                              db.addFollowerAndFollowing(
                                user.uid,
                                reqUsers[index].uid,
                              );
                              setState(() {
                                firsttime = true;
                              });
                            },
                          ),
                        ),
                      );
                    }, childCount: reqUsers.length),
              )
            ]);
                  }
                )),
          )
        : _selectedIndex == 0
            ? HomePage(
                index: widget.index,
              )
            : _selectedIndex == 1
                ? SearchPage(
                    index: widget.index,
                  )
                : _selectedIndex == 2
                    ? PostPage(
                        index: widget.index,
                      )
                    : SettingsPage(
                        index: widget.index,
                      );
  }
}
