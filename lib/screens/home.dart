import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:reach_me/components/PostCard.dart';
import 'package:reach_me/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/Post.dart';
import 'search.dart';
import 'post.dart';
import 'notifications.dart';
import 'account.dart';

import '../services/receive.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';

class HomePage extends StatefulWidget {
  final int index;
  HomePage({this.index});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> post = [];
  int _selectedIndex = 0;
  String uid;
  bool firstTime = true;
  Database db = Database();
  AuthProvider _authProvider = AuthProvider();

  void reload(String uid) {
    db.getPostData(uid).then((value) => setState(() {
          post = value;
          print(value.toString() + 'hello');
        }));
  }

  Future<String> refresh(String uid) async {
    //url = await Receive().getData();
//    print("Refresh "+url);
    return await Receive().getData(uid);
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.index;
    var user = Provider.of<FirebaseUser>(context);
    if (firstTime) {
      print("Hello There");
      reload(user.uid);
      firstTime = false;
    }
    return _selectedIndex == 0
        ? Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  reload(user.uid);
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
                    _authProvider.logout();
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
                              callBack: () {
                                setState(() {

                                });
                              },
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
