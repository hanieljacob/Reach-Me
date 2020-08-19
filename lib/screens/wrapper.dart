import 'package:flutter/material.dart';
import '../components/bottom_navbar.dart';
import '../screens/home.dart';
import 'search.dart';
import 'post.dart';
import 'notifications.dart';
import 'account.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int current_tab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: current_tab,
        onItemTapped: (value){
            setState(() {
              current_tab = value;
            });
        },
      ),
      body: IndexedStack(
        children: <Widget>[
          HomePage(),
          SearchPage(),
          PostPage(),
          NotificationsPage(),
          SettingsPage(),
        ],
        index: current_tab,
      ),
    );
  }
}
