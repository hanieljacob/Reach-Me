import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/services/database.dart';

class FollowingPage extends StatefulWidget {
  final List followers;
  final String uid;
  final String title;
  FollowingPage({this.followers,this.uid,@required this.title});
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {

  List<User> followers = [];
  Database db = Database();
  bool firstTime = true;
  List<bool> boolList = [];

  void unfollow(){
    followers.forEach((element) {
      boolList.add(true);
    });
  }

  void getFollowers(List follower) {
    db.getFollowers(follower).then((value) => setState((){
      followers = value;
      print(value);
      unfollow();
    }));
  }
  @override
  Widget build(BuildContext context) {
    if(firstTime == true){
      getFollowers(widget.followers);
      firstTime = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toString()),
      ),
      body:  ListView.builder(itemCount: widget.followers.length,itemBuilder: (BuildContext context,int index){
        return followers.length==0?SizedBox.shrink():boolList[index]?ListTile(
          onTap: () {},
          leading: CircleAvatar(
            backgroundImage:
            NetworkImage(followers[index].photoUrl),
          ),
          title: Text(followers[index].name),
          trailing: widget.title.toString() == "Likes"?SizedBox.shrink():FlatButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: Text('Unfollow'),
            onPressed: () {
              db.unfollow(widget.uid, followers[index].uid);
              setState(() {
                boolList[index] = false;
              });
            },
          ),
        ):SizedBox.shrink();
      }),
    );
  }
}
