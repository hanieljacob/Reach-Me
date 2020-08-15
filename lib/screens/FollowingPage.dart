import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/services/database.dart';

class FollowingPage extends StatefulWidget {
  final List followers;
  final String uid;
  FollowingPage({this.followers,this.uid});
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {

  List<User> followers = [];
  Database db = Database();
  bool firstTime = true;
  void getFollowers(List follower) {
    db.getFollowers(follower).then((value) => setState((){
      followers = value;
    }));
  }
  @override
  Widget build(BuildContext context) {
    if(firstTime == true){
      getFollowers(widget.followers);
      firstTime = false;
    }
    return Scaffold(
      body:  ListView.builder(itemCount: widget.followers.length,itemBuilder: (BuildContext context,int index){
        return followers.length==0?SizedBox.shrink():ListTile(
          onTap: () {},
          leading: CircleAvatar(
            backgroundImage:
            NetworkImage(followers[index].photoUrl),
          ),
          title: Text(followers[index].name),
          trailing: FlatButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: Text('Unfollow'),
            onPressed: () {
              db.disconnect(widget.uid, followers[index].uid);
              setState(() {
                firstTime = true;
              });
            },
          ),
        );
      }),
    );
  }
}
