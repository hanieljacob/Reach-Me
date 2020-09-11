import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/add_group.dart';
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_pin)),
              Tab(icon: Icon(Icons.group)),
            ],
          ),
          title: Text('Messages'),
        ),
        body: TabBarView(
          children: [
            ChatTab(uid: widget.uid, user: widget.user),
            GroupChat(
              user: widget.user,
            ),
          ],
        ),
      ),
    );
  }
}

class GroupChat extends StatefulWidget {
  final User user;
  GroupChat({this.user});
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            leading: Icon(
              Icons.supervised_user_circle,
              size: 40,
            ),
            title: Text('Create New Group'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddGroup(
                            user: widget.user,
                          )));
            }),
      ],
    );
  }
}

class ChatTab extends StatefulWidget {
  final String uid;
  final User user;
  ChatTab({this.uid, this.user});
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  Database db = Database();
  List<String> chatId = [];
  String chatID;
  int temp = 0;
  String test;

  void refresh() {
    setState(() {
      temp = 1;
    });
  }

  void getUserData(var curUser) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    return StreamBuilder(
                        stream: Firestore.instance
                            .collection('Messages')
                            .document(chatID)
                            .collection(chatID)
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (context, snapshot2) {
                          return !snapshot2.hasData
                              ? SizedBox.shrink()
                              : ListTile(
                                  title: Text(
                                      snapshot.data.documents[index]['name']),
                                  subtitle: snapshot2.data.documents.length != 0
                                      ? Text(snapshot2.data.documents[0]
                                          ['content'])
                                      : SizedBox.shrink(),
                                  onTap: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                user: widget.user,
                                                user2: snapshot
                                                    .data.documents[index],
                                                callback: () {
                                                  refresh();
                                                })));
                                    // setState(() {
                                    //   test = result;
                                    //   print(result);
                                    // });
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot
                                        .data.documents[index]['userphoto']),
                                  ),
                                );
                        });
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
