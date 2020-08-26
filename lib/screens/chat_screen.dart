import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/components/loading.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/services/database.dart';

class ChatScreen extends StatefulWidget {
  var user2;
  final User user;
  ChatScreen({this.user,this.user2});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Database db = Database();
  User user2;
  TextEditingController _controller;
  String text;
  List messages = [];
  String chatId;
  void createUserData(var element){
    setState(() {
      user2 = db.createUser(
        element['name'],
        element['uid'],
        element['userphoto'],
        element['posts'],
        element['followers'],
        element['following'],
        element['requests'],
        element['requested'],
        element['saved'],
      );
    });
    if(widget.user.uid.hashCode <= user2.uid.hashCode)
      chatId = '${widget.user.uid}-${user2.uid}';
    else
      chatId = '${user2.uid}-${widget.user.uid}';
  }

  @override
  Widget build(BuildContext context) {
    createUserData(widget.user2);
//    db.sendMessage(widget.user.uid, user2.uid, "hi", 0);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            user2.name
          ),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('Messages').document(chatId).collection(chatId).orderBy('time', descending: false).snapshots(),
          builder: (context, snapshot){
            return snapshot.hasData? CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index){
                            return ListTile(
                              title: Text(snapshot.data.documents[index]['content']),
                            );
                          },
                          childCount: snapshot.data.documents.length
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                  Icons.image
                              ),
                            ),
                            ConstrainedBox(
                              constraints:  BoxConstraints.tight(Size(250,50)),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                cursorColor: Colors.black,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                autofocus: false,
                                controller: _controller,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                onChanged: (value) {
                                  setState(() {
                                    text = value;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                  Icons.send
                              ),
                              onPressed: () async{
                                if(text != null) {
                                  db.sendMessage(widget.user.uid, user2.uid, text , 0, chatId);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ) : Loading();
              },
    )
    )
    );
  }
}
