import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/services/database.dart';

class CommentsPage extends StatefulWidget {
  final String postUser;
  final String postId;
  CommentsPage({this.postUser, this.postId});
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _controller = TextEditingController();
  String comment;
  bool firstTime = true;
  List comments = [];
  Database db = Database();
  @override
  Widget build(BuildContext context) {
    if (firstTime == true) {
      db
          .getComments(widget.postUser, widget.postId)
          .then((value) => setState(() {
                comments = value;
              }));
      firstTime = false;
    }
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return ListTile(
                  subtitle: Text(db.convertTime(comments[index]['time'])),
                  onTap: () {},
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comments[index]['userPic']),
                  ),
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: comments[index]['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: '  '),
                        TextSpan(text: "\n"),
                        TextSpan(text: comments[index]['comment']),
                      ],
                    ),
                  ));
            }, childCount: comments.length),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 20,
                      child: ClipOval(
                        child: Image.network(
                          user.photoUrl,
                        ),
                      ),
                      // backgroundImage: NetworkImage(user.photoUrl),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add a comment ${user.displayName}",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
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
                          comment = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (_controller.text != '') {
                        await db.addComment(
                            user.uid, widget.postUser, comment, widget.postId);
                        db
                            .getComments(widget.postUser, widget.postId)
                            .then((value) => setState(() {
                                  comments = value;
                                }));
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
