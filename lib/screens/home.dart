import 'package:reach_me/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'search.dart';
import 'post.dart';
import 'notifications.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 0 ? Scaffold(
      bottomNavigationBar: BottomNavBar(
          selectedIndex: 0, onItemTapped: (index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {

          },
          icon: Icon(
            Icons.public,
            color: Colors.white,
          ),
        ),
        title: Center(child: Text("ReachMe")),
        actions: <Widget>[
          IconButton(
            onPressed: () {

            },
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
            SizedBox(height: 250,),
            Center(
              child: Text("Follow accounts to view content", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400
              ),
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
    ) : _selectedIndex == 1 ? SearchPage() : _selectedIndex == 2
        ? PostPage()
        : _selectedIndex == 3 ? NotificationsPage() : SettingsPage();
  }
}