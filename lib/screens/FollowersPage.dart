import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/services/database.dart';

class FollowersPage extends StatefulWidget {
  final List followers;
  final String uid;
  FollowersPage({this.followers,this.uid});
  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {

  List<User> followers = [];
  Database db = Database();
  bool firstTime = true;
  List<bool> boolList = [];

  void disconnect(){
      followers.forEach((element) {
        boolList.add(true);
      });
  }

  void getFollowers(List follower) {
    db.getFollowers(follower).then((value) => setState((){
      followers = value;
      disconnect();
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
        title: Text(
          'Followers'
        ),
      ),
      body:  ListView.builder(itemCount: widget.followers.length,itemBuilder: (BuildContext context,int index){
        return followers.length==0?SizedBox.shrink():boolList[index]?ListTile(
          onTap: () {},
          leading: CircleAvatar(
            backgroundImage:
            NetworkImage(followers[index].photoUrl),
          ),
          title: Text(followers[index].name),
          trailing: FlatButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: Text('Disconnect'),
            onPressed: () {
              db.disconnect(widget.uid, followers[index].uid);
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
