import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/models/Post.dart';

class PostCard extends StatefulWidget {
  final Post post;
  PostCard({this.post});
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
      child: Material(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    child: ClipOval(
                      child: Image.network(
                        widget.post.userphoto,
                      ),
                    ),
                    // backgroundImage: NetworkImage(user.photoUrl),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.post.username,
                  ),
                ),
              ],
            ),
            Image.network(
              widget.post.photoUrl
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.comment,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.favorite_border,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.share,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
