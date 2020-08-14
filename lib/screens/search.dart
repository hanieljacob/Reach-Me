import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'post.dart';
import 'notifications.dart';
import 'settings.dart';
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
  FocusNode _textFocus = new FocusNode();
  Database db = Database();
  List<User> users = [];
  List<String> userName = [];
  bool firstime = true;
  void getUsers(userUid) {
    db.getUsers(userUid).then(
          (value) => setState(() {
            users = value;
            users.forEach((element) {
              userName.add(element.name);
            });
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
    return _selectedIndex == 1
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: TextFormField(
                  controller: _controller,
                  onChanged: (value){
                    setState(() {
                      searchedName = value;
                    });
                  },
                ),
                leading: Icon(
                  Icons.search
                ),
                backgroundColor: Colors.blue,
              ),
              bottomNavigationBar: BottomNavBar(
                  selectedIndex: 1,
                  onItemTapped: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
              body: users.length == 0
                  ? Center(
                      child: Text('Users'),
                    )
                  : UsersList(users: users,searchedName:searchedName,userNames: userName,uid: user.uid,)
            ),
          )
        : _selectedIndex == 0
            ? HomePage()
            : _selectedIndex == 2
                ? PostPage()
                : _selectedIndex == 3 ? NotificationsPage() : SettingsPage();
  }
}
