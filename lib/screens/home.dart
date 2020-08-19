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
import '../components/bottom_navbar.dart';
import '../services/receive.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import '../components/loading.dart';

class HomePage extends StatefulWidget {
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
//    refresh(uid).then((val) => setState(() {
//          url = val;
//        }));
    db.getPostData(uid).then((value) => setState(() {
          post = value;
        }));
  }

  Future<String> refresh(String uid) async {
    //url = await Receive().getData();
//    print("Refresh "+url);
    return await Receive().getData(uid);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    if (firstTime) {
      reload(user.uid);
      firstTime = false;
    }
    return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {},
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
              onRefresh: () async{
                reload(user.uid);
                return await Future.delayed(Duration(seconds: 3));
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
                                  child: Loading()))
                          : PostCard(
                              post: post[index],
                            );
                    }, childCount: post.length == 0 ? 1 : post.length),
                  )
                ],
              ),
            ),
          );
  }
}
