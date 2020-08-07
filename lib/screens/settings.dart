import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'post.dart';
import 'notifications.dart';
import '../components/bottom_navbar.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex=4;

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 4 ? Scaffold(
      bottomNavigationBar: BottomNavBar(
          selectedIndex: 4, onItemTapped: (index) {
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
              child: Text("Manage your settings", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400
              ),
              ),
            ),
          ],
        ),
      ),
    ) : _selectedIndex == 0? HomePage() : _selectedIndex == 1? SearchPage() : _selectedIndex == 2? PostPage() : NotificationsPage();
  }
}
