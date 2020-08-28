// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/profile.dart';
import '../services/database.dart';

class UsersList extends StatefulWidget {
  final User curUser;
  final List<User> users;
  final List userNames;
  final String searchedName;
  final String uid;
  final VoidCallback rebuild;
  UsersList(
      {this.users,
      this.searchedName,
      this.userNames,
      this.uid,
      this.curUser,
      this.rebuild});
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  Database db = Database();
  List boolList = [];

  void search() {
    print(widget.curUser.followers);
    List boollist = [];
    widget.userNames.forEach((element) {
      boollist.add(element
          .toString()
          .toLowerCase()
          .contains(widget.searchedName.toLowerCase()));
    });
    setState(() {
      boolList = boollist;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<FirebaseUser>(context);
    search();
    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          // print('Outside ' + widget.users[index].uid);
          if (widget.searchedName == '') {
            return null;
          } else if (boolList[index]) {
            // print('Inside true' + index.toString());
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 5,
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                uid: widget.users[index].uid,
                                user: widget.curUser,
                              ))).then((value) {
                    setState(() {
                      widget.rebuild();
                    });
                  });
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.users[index].photoUrl),
                ),
                title: Text(widget.users[index].name),
                trailing: widget.curUser.following
                        .contains(widget.users[index].uid)
                    ? FlatButton(
                        textColor: Colors.white,
                        color: Colors.blueGrey[300],
                        child: Text('Reached Out'),
                        onPressed: () {},
                      )
                    : widget.curUser.requested.contains(widget.users[index].uid)
                        ? FlatButton(
                            textColor: Colors.blue,
                            color: Colors.white,
                            child: Text('Reaching..'),
                            onPressed: () {},
                          )
                        : FlatButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Text('Reach Out!'),
                            onPressed: () {
                              db.createRequest(
                                  widget.uid, widget.users[index].uid);
                              widget.rebuild();
                            },
                          ),
              ),
            );
          } else {
            // print('Outside false' + index.toString());
            return SizedBox.shrink();
          }
        }, childCount: widget.users.length),
      )
    ]);
  }
}
