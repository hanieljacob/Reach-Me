import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/models/User.dart';
import 'home.dart';
import 'search.dart';
import 'post.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';
import '../services/database.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex=3;
  bool firsttime = true;
  List<User> users = [];
  Database db = Database();
  void getUsers(String uid){
//    db.getUsers(uid).then((value) { setState((){users = value;});});

  }
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    if(firsttime) {
      getUsers(user.uid);
      firsttime = false;
    }
    return _selectedIndex == 3 ? Scaffold(
      bottomNavigationBar: BottomNavBar(
          selectedIndex: 3, onItemTapped: (index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
      body: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    onTap: (){

                    },
                    leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(users[index].photoUrl),
                    ),
                    title: Text(users[index].name),
                    trailing: FlatButton(
                      color: Colors.blue,
                      child: Text(
                          'Accept'
                      ),
                      onPressed: (){

//                    print(widget.users[index].uid);
                      },
                    ),
                  ),
                );
              }, childCount: users.length),
        )
      ])
    ) : _selectedIndex == 0? HomePage() : _selectedIndex == 1? SearchPage() : _selectedIndex == 2? PostPage() : SettingsPage();
  }
}
