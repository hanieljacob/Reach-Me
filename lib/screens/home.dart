import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:reach_me/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'search.dart';
import 'post.dart';
import 'notifications.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';

import '../services/receive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url;
  int _selectedIndex = 0;
  String uid;

  void reload(String uid) {
    refresh(uid).then((val) => setState(() {
          url = val;
        }));
  }

  Future<String> refresh(String uid) async {
    //url = await Receive().getData();
//    print("Refresh "+url);
    return await Receive().getData(uid);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return _selectedIndex == 0
        ? Scaffold(
            bottomNavigationBar: BottomNavBar(
                selectedIndex: 0,
                onItemTapped: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.public,
                  color: Colors.white,
                ),
              ),
              title: Center(child: Text("ReachMe")),
              actions: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 250,
                  ),
                  Center(
                    child: Text(
                      "",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                  url != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Image.network(url))
                      : SizedBox(height: 2),
                  Center(
                    child: RaisedButton(
                      child: Text('Refresh'),
                      onPressed: () {
                        uid = user.uid;
                        reload(uid);
                      },
                    ),
                  ),
                  Center(
                    child: RaisedButton(
                      child: Text('Log out'),
                      onPressed: () {
                        AuthProvider().logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : _selectedIndex == 1
            ? SearchPage()
            : _selectedIndex == 2
                ? PostPage()
                : _selectedIndex == 3 ? NotificationsPage() : SettingsPage();
  }
}
