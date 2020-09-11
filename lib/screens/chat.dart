import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/chat_screen.dart';
import 'package:reach_me/services/database.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  final User user;
  ChatPage({this.uid, this.user});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Database db = Database();
  List<String> chatId = [];
  String chatID;
  int temp = 0;

  void getUserData(var curUser) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
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
              snapshot.data.documents.forEach((element) {
                if (widget.user.followers.contains(element['uid']) ||
                    widget.user.following.contains(element['uid'])) if (widget
                        .user.uid.hashCode <=
                    element['uid'].hashCode)
                  chatId.add('${widget.user.uid}-${element['uid']}');
                else
                  chatId.add('${element['uid']}-${widget.user.uid}');
              });

              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  print(snapshot.data.documents.length);
                  print(chatId.toString());
                  if (snapshot.data.documents[index]['uid'] == widget.uid)
                    return SizedBox.shrink();
                  else if (widget.user.followers
                          .contains(snapshot.data.documents[index]['uid']) ||
                      widget.user.following
                          .contains(snapshot.data.documents[index]['uid'])) {
                    if (widget.user.uid.hashCode <=
                        snapshot.data.documents[index]['uid'].hashCode)
                      chatID =
                          '${widget.user.uid}-${snapshot.data.documents[index]['uid']}';
                    else
                      chatID =
                          '${snapshot.data.documents[index]['uid']}-${widget.user.uid}';
                    return widget.user.chatIds.contains(chatID)
                        ? StreamBuilder(
                            stream: Firestore.instance
                                .collection('Messages')
                                .document(chatID)
                                .collection(chatID)
                                .orderBy('time', descending: true)
                                .snapshots(),
                            builder: (context, snapshot2) {
                              return ListTile(
                                title: Text(
                                    snapshot.data.documents[index]['name']),
                                subtitle: Text(
                                    snapshot2.data.documents[0]['content']),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                                user: widget.user,
                                                user2: snapshot
                                                    .data.documents[index],
                                              )));
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data.documents[index]['userphoto']),
                                ),
                              );
                            })
                        : ListTile(
                            title: Text(snapshot.data.documents[index]['name']),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            user: widget.user,
                                            user2:
                                                snapshot.data.documents[index],
                                          )));
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data.documents[index]['userphoto']),
                            ),
                          );
                  } else
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
