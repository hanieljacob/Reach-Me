import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'post.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex=3;

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 3 ? Scaffold(
      bottomNavigationBar: BottomNavBar(
          selectedIndex: 3, onItemTapped: (index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 250,),
            Center(
              child: Text("Your notifications appear here", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400
              ),
              ),
            ),
          ],
        ),
      ),
    ) : _selectedIndex == 0? HomePage() : _selectedIndex == 1? SearchPage() : _selectedIndex == 2? PostPage() : SettingsPage();
  }
}
