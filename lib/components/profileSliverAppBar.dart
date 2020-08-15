import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/FollowersPage.dart';
import 'package:reach_me/screens/FollowingPage.dart';

class ProfileSliverAppBar extends StatefulWidget {
  final int followers;
  final int following;
  final int posts;
  const ProfileSliverAppBar({
    @required this.user,
    this.posts,
    this.followers,
    this.following,
  });

  final User user;

  @override
  _ProfileSliverAppBarState createState() => _ProfileSliverAppBarState();
}

class _ProfileSliverAppBarState extends State<ProfileSliverAppBar> {
  bool firstTime = true;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Profile'),
      backgroundColor: Colors.blue,
      expandedHeight: 275.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                child: ClipOval(
                  child: Image.network(
                    widget.user.photoUrl,
                  ),
                ),
                // backgroundImage: NetworkImage(user.photoUrl),
                backgroundColor: Colors.transparent,
              ),
              Center(
                child: Text(
                  'Hello, ' + widget.user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 27.5,
                      vertical: 13,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Posts',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          widget.posts.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FollowersPage(followers: widget.user.followers,uid: widget.user.uid)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 27.5,
                        vertical: 13,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Followers',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            widget.followers.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FollowingPage(followers: widget.user.following,uid: widget.user.uid)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 27.5,
                        vertical: 13,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Following',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            widget.following.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

