import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/chat_screen.dart';
import 'package:reach_me/services/database.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  final User user;
  ChatPage({this.uid,this.user});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Database db = Database();
  
  void getUserData(var curUser){
    setState(() {

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages'
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  if(snapshot.data.documents[index]['uid'] == widget.user.uid)
                    return SizedBox.shrink();
                  else if(widget.user.followers.contains(snapshot.data.documents[index]['uid']) || widget.user.following.contains(snapshot.data.documents[index]['uid']))
                  return ListTile(
                    title: Text(
                        snapshot.data.documents[index]['name']
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(user: widget.user, user2: snapshot.data.documents[index],)));
                    },
                    leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(snapshot.data.documents[index]['userphoto']),
                    ),
                  );
                  else
                    return SizedBox.shrink();
                },
                  itemCount: snapshot.data.documents.length,
                );
            }
          },
        ),
      ),
    );
  }
}
