import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/components/AccountDrawer.dart';
import 'package:reach_me/components/PostCard.dart';
import 'package:reach_me/models/Post.dart';
import '../components/loading.dart';
import '../models/User.dart';
import '../components/profileSliverAppBar.dart';
import '../services/database.dart';
import 'home.dart';
import 'search.dart';
import 'post.dart';
import 'notifications.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final User user;
  ProfilePage({this.uid,this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;
  List postsUrl = [];
  List text = [];
  User userData;
  String username;
  Database db = Database();
  bool firstime = true;
  bool loading = true;

  List<Post> post = [];

  void getposts(String uid) async {
    post = [];
    await db.getUser(uid).then((value) =>
        setState(() {
          userData = value;
          print(userData);
        }));
    await db.userPostData(uid).then((value) =>
        setState(() {
          post = value;
          print(value);
        }));
  }

  Future getPostUrl(String uid) async {
    return await db.getUser(uid);
  }

  @override
  Widget build(BuildContext context) {
    if (firstime) {
      getposts(widget.uid);
      firstime = false;
    }
    return SafeArea(
      child: Scaffold(
        body: userData == null
            ? Loading()
            : CustomScrollView(
          slivers: <Widget>[
            ProfileSliverAppBar(
              reload: (){
                getposts(widget.uid);
              },
              curUser: widget.user,
              isAccount: false,
              user: userData,
              posts: userData == null ? 0 : post.length,
              followers:
              userData == null ? 0 : userData.followers.length,
              following:
              userData == null ? 0 : userData.following.length,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return widget.user.following.contains(widget.uid)?post.length == 0
                        ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Text(
                              'Oops! Looks like you havent posted anything yet.'),
                        ))
                        : PostCard(
                      post: post[index], accountsPage: true, callback: () {
                      setState(() {
                        getposts(widget.uid);
                      });
                    },
                    ):Text('This account is a private account');
                  }, childCount: widget.user.following.contains(widget.uid)?post.length == 0 ? 1 : post.length:1),
            )
          ],
        ),
      ),
    );
  }
}
