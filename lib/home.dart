import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text(''),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          unselectedItemColor: Colors.grey[800],
          onTap: _onItemTapped,
        ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.public,
            color: Colors.white,
          ),
        ),
        title: Center(child: Text("ReachMe")),
        actions: <Widget>[
          IconButton(
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
            Text("Home Page"),
            RaisedButton(
              child: Text('Log out'),
              onPressed: (){
                AuthProvider().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
