import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'post.dart';
import 'notifications.dart';
import 'account.dart';
import '../components/bottom_navbar.dart';
import '../services/database.dart';
import '../models/User.dart';
import '../components/sliver_list.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 1;
  String searchedName = '';
  TextEditingController _controller = new TextEditingController();
  // FocusNode _textFocus = new FocusNode();
  Database db = Database();
  User curUser;
  List<User> users = [];
  List userName = [];
  bool firstime = true;
  void getUsers(userUid) {
    db.getUser(userUid).then(
          (value) => setState(() {
            curUser = value;
          }),
        );
    db.getUsers(userUid).then(
          (value) => setState(() {
            users = value;
            users.forEach((element) {
              userName.add(element.name.toString());
            });
            // print(users);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    if (firstime) {
      getUsers(user.uid);
      firstime = false;
    }
    return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search User...",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: false,
                  controller: _controller,
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      searchedName = value;
                    });
                  },
                ),
                leading: Icon(Icons.search),
                backgroundColor: Colors.blue,
              ),
              body: users.length == 0
                  ? SizedBox.shrink()
                  : UsersList(
                      rebuild: () {
                        setState(() {
                          firstime = true;
                        });
                      },
                      users: users,
                      searchedName: searchedName,
                      userNames: userName,
                      uid: user.uid,
                      curUser: curUser,
                    ),
            ),
          );
  }
}
