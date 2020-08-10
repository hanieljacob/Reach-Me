import 'package:reach_me/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'search.dart';
import 'post.dart';
import 'notifications.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/receive.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url;
  int _selectedIndex = 0;


  void reload(){
    refresh().then((val) => setState(() {
      url = val;
    }));
  }

  Future<String> refresh() async{
    //url = await Receive().getData();
//    print("Refresh "+url);
    return await Receive().getData();
  }

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
              child: Text("", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400
              ),
              ),
            ),
        url!=null?Image.network(url):SizedBox(height: 2),
        Center(
          child: RaisedButton(
            child: Text('Refresh'),
            onPressed: () {
              reload();
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
    ) : _selectedIndex == 1 ? SearchPage() : _selectedIndex == 2
        ? PostPage()
        : _selectedIndex == 3 ? NotificationsPage() : SettingsPage();
  }
}