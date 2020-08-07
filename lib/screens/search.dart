import 'package:flutter/material.dart';
import 'home.dart';
import 'post.dart';
import 'notifications.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex=1;

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 1 ? Scaffold(
      bottomNavigationBar: BottomNavBar(
          selectedIndex: 1, onItemTapped: (index) {
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
              child: Text("Search for other users", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400
              ),
              ),
            ),
          ],
        ),
      ),
    ) : _selectedIndex == 0? HomePage() : _selectedIndex == 2? PostPage() : _selectedIndex == 3? NotificationsPage() : SettingsPage();
  }
}
