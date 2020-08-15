import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/loading.dart';
import '../models/User.dart';
import '../components/profileSliverAppBar.dart';
import '../services/database.dart';
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
  int _selectedIndex = 4;
  List postsUrl = [];
  List text = [];
  User userData;
  String username;
  String uid;
  Database db = Database();
  bool firstime = true;

  void getposts(String uid) {
    getPostUrl(uid).then(
      (value) => setState(
        () {
          userData = value;
          // print(userData);
          userData.posts.forEach(
            (element) {
              postsUrl.add(element['photoUrl']);
              text.add(element['text']);
            },
          );
        },
      ),
    );
  }

  Future getPostUrl(String uid) async {
    return await db.getUser(uid);
  }



  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    uid = user.uid;
    if (firstime) {
      getposts(uid);
      firstime = false;
    }
    return _selectedIndex == 4
        ? SafeArea(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(
                  selectedIndex: 4,
                  onItemTapped: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
              body: userData == null
                  ? Loading()
                  : CustomScrollView(
                      slivers: <Widget>[
                        ProfileSliverAppBar(
                          user: userData,
                          posts:
                              userData == null ? 0 : userData.posts.length,
                          followers:
                              userData == null ? 0 : userData.followers.length,
                          following:
                              userData == null ? 0 : userData.following.length,
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return postsUrl.length == 0
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: Text(
                                        'Oops! Looks like you havent posted anything yet.'),
                                  ))
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 30,
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Image.network(postsUrl[index]),
                                        Text(text[index]),
                                      ],
                                    ),
                                  );
                          },
                              childCount:
                                  postsUrl.length == 0 ? 1 : postsUrl.length),
                        )
                      ],
                    ),
            ),
          )
        : _selectedIndex == 0
            ? HomePage()
            : _selectedIndex == 1
                ? SearchPage()
                : _selectedIndex == 2 ? PostPage() : NotificationsPage();
  }
}
