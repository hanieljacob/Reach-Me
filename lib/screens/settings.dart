import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/components/loading.dart';
import 'package:reach_me/services/database.dart';
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
  String username;
  String uid;
  Database db = Database();
  bool firstime = true;

  void getposts(String uid) {
    getPostUrl(uid).then(
      (value) => setState(
        () => {
          value.forEach(
            (element) {
              postsUrl.add(element['photoUrl']);
              text.add(element['text']);
            },
          )
        },
      ),
    );
  }

  Future getPostUrl(String uid) async {
    return await db.getPosts(uid);
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
              body: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          title: Text('Profile'),
                          backgroundColor: Colors.blue,
                          expandedHeight: 200.0,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text('Hello, ' + user.displayName),
                            centerTitle: true,
                            background: CircleAvatar(
                              radius: 30,
                              child: ClipOval(
                                child: Image.network(
                                  user.photoUrl,
                                ),
                              ),
                              // backgroundImage: NetworkImage(user.photoUrl),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return postsUrl.length == 0
                                ? SizedBox.shrink()
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
                          }, childCount: postsUrl.length),
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
