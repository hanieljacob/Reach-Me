import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/services/database.dart';

class CommentsPage extends StatefulWidget {
    final String postUser;
    final String postId;
    CommentsPage({this.postUser,this.postId});
    @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _controller;
  String comment;
  Database db = Database();
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments'
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SafeArea(
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
              ConstrainedBox(
                constraints:  BoxConstraints.tight(Size(250,50)),
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
                icon: Icon(
                  Icons.add_comment
                ),
                onPressed: (){
                  db.addComment(user.uid, widget.postUser, comment, widget.postId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
