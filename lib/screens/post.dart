import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'notifications.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int _selectedIndex=2;

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 2 ? Scaffold(
      bottomNavigationBar: BottomNavBar(
          selectedIndex: 2, onItemTapped: (index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text("Create a post", style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
              ),
              ),
            ),
          ],
        ),
      ),
    ) : _selectedIndex == 0? HomePage() : _selectedIndex == 1? SearchPage() : _selectedIndex == 3? NotificationsPage() : SettingsPage();
  }
}
