import 'package:flutter/material.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/FollowersPage.dart';
import 'package:reach_me/screens/FollowingPage.dart';
import 'package:reach_me/services/database.dart';

class ProfileSliverAppBar extends StatefulWidget {
  final int followers;
  final int following;
  final int posts;
  final bool isAccount;
  final User curUser;
  final Function reload;
  const ProfileSliverAppBar({
    @required this.user,
    this.posts,
    this.followers,
    this.following,
    this.isAccount,
    this.curUser,
    this.reload,
  });

  final User user;

  @override
  _ProfileSliverAppBarState createState() => _ProfileSliverAppBarState();
}

class _ProfileSliverAppBarState extends State<ProfileSliverAppBar> {
  Database db = Database();
  bool firstTime = true;
  User user2;
  void getData(String uid){
    db.getUser(uid).then((value) {
      setState(() {
        user2 = value;
      });
    });
  }

  Widget follow(){
    return user2.followers
        .contains(widget.curUser.uid)
        ? FlatButton(
      textColor: Colors.white,
      color: Colors.blueGrey[300],
      child: Text('Reached Out'),
      onPressed: () {},
    )
        : user2.requests.contains(widget.curUser.uid)
        ? FlatButton(
      textColor: Colors.blue,
      color: Colors.white,
      child: Text('Reaching..'),
      onPressed: () {},
    )
        : FlatButton(
      textColor: Colors.white,
      color: Colors.blue,
      child: Text('Reach Out!'),
      onPressed: () {
        db.createRequest(
            widget.curUser.uid, widget.user.uid);
        getData(widget.user.uid);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(firstTime){
      user2 = widget.user;
      firstTime = false;
    }
    return SliverAppBar(
      actions: <Widget>[
        if(!widget.isAccount)
          follow()
      ],
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
                  widget.isAccount?'Hello, ' + widget.user.name : widget.user.name,
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
                    onTap: () {
                      if(widget.isAccount)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FollowersPage(
                                  followers: widget.user.followers,
                                  uid: widget.user.uid)));
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
                    onTap: () {
                      if(widget.isAccount)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FollowingPage(
                                  followers: widget.user.following,
                                  uid: widget.user.uid,
                                  title: "Following",)));
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
