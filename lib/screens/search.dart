import 'package:flutter/material.dart';
import 'home.dart';
import 'post.dart';
import 'notifications.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';
import '../services/database.dart';
import '../models/User.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 1;
  Database db = Database();
  List<User> users = [];
  bool firstime = true;
  void getUsers() {
    db.getUsers().then(
          (value) => setState(() {
            users = value;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (firstime) {
      getUsers();
      firstime = false;
    }
    return _selectedIndex == 1
        ? SafeArea(
            child: Scaffold(
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
                  : CustomScrollView(slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(users[index].photoUrl),
                                  ),
                                  title: Text(users[index].name),
                                )
                              ],
                            ),
                          );
                        }, childCount: users.length),
                      )
                    ]),
            ),
          )
        : _selectedIndex == 0
            ? HomePage()
            : _selectedIndex == 2
                ? PostPage()
                : _selectedIndex == 3 ? NotificationsPage() : SettingsPage();
  }
}
