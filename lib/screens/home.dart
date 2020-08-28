import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:reach_me/components/PostCard.dart';
import 'package:reach_me/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/Post.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/chat.dart';
import 'package:reach_me/services/push_token.dart';
import 'search.dart';
import 'post.dart';
import 'notifications.dart';
import 'account.dart';

import 'package:provider/provider.dart';
import '../services/database.dart';

class HomePage extends StatefulWidget {
  final int index;
  HomePage({this.index});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Post> post = [];
  int _selectedIndex = 0;
  String uid;
  User user2;
  bool firstTime = true;
  Database db = Database();
  AuthProvider _authProvider = AuthProvider();

  void reload(String uid) {
    db.getUser(uid).then((value) => user2 = value);
    db.getPostData(uid).then((value) => setState(() {
          post = value;
          print(value.toString() + 'hello');
        }));
  }

  @override
    void initState() {
      super.initState();
      firebaseCloudMessaging_Listeners();
    }

    void firebaseCloudMessaging_Listeners() {
      if (Platform.isIOS) iOS_Permission();

      _firebaseMessaging.getToken().then((token){

      });

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
        },
      );
    }

    void iOS_Permission() {
      _firebaseMessaging.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true)
      );
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }

  @override
  Widget build(BuildContext context) {

    _selectedIndex = widget.index;
    var user = Provider.of<FirebaseUser>(context);
    if (firstTime) {
      print("Hello There");
      reload(
        user.uid,
      );
      firstTime = false;
    }
    return _selectedIndex == 0
        ? Scaffold(
            backgroundColor: Colors.grey[100],
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(uid: user.uid, user: user2)));
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                reload(user.uid);
                return await Future.delayed(Duration(seconds: 2));
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return post.length == 0
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Text('No Post'),
                              ),
                            )
                          : PostCard(
                              post: post[index],
                              accountsPage: false,
                            );
                    }, childCount: post.length == 0 ? 1 : post.length),
                  )
                ],
              ),
            ),
          )
        : _selectedIndex == 1
            ? SearchPage(
                index: widget.index,
              )
            : _selectedIndex == 2
                ? PostPage(
                    index: widget.index,
                  )
                : _selectedIndex == 3
                    ? NotificationsPage(
                        index: widget.index,
                      )
                    : SettingsPage(
                        index: widget.index,
                      );
  }
}
