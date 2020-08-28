import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/models/Post.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/screens/FollowingPage.dart';
import 'package:reach_me/screens/account.dart';
import 'package:reach_me/screens/comments.dart';
import 'package:reach_me/screens/profile.dart';

import 'package:reach_me/services/database.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool accountsPage;
  final Function callback;
  PostCard({this.post, @required this.accountsPage, this.callback});
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int len = 0;
  bool like = false;
  List saved = [];
  User currentUser;

  Database db = Database();

  showAlertDialog(BuildContext context, String postUser, String postId) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: ListTile(
        title: Text('Delete'),
        onTap: () {
          db.deletePost(postUser, postId);
          Navigator.of(context).pop();
          widget.callback();
        },
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool likedOrNot(String uid, List likes) {
    bool isLiked = likes.contains(uid);
    return isLiked;
  }

  void getData(String uid) async {
    List users2 = [];
    await db.getUser(uid).then((User value) {
      value.saved.forEach((element) {
        users2.add(element['id']);
      });
      setState(() {
        currentUser = value;
        saved = users2;
      });
    });
//    await db.getSavedPostId(uid).then((value) => setState((){saved=value;}));
  }

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    List likes = [];

    if (firstTime) {
      getData(user.uid);
      print("FT: " + widget.post.likes.toString());
      setState(() {
        len = widget.post.likes.length;
        like = widget.post.likes.contains(user.uid);
      });
      firstTime = false;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(12.0),
          bottomRight: const Radius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (widget.post.uid != currentUser.uid)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    uid: widget.post.uid,
                                    user: currentUser,
                                  )));
                    else
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage(
                                    index: 4,
                                  )));
                  },
                  child: Row(
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
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        child: Text(
                          widget.post.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.accountsPage) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: () {
                        showAlertDialog(context, user.uid, widget.post.id);
//                      PopUp(context: context, postUser: user.uid, postId: widget.post.id);
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ),
                ]
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
              child: GestureDetector(
                child: Image.network(
                  widget.post.photoUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
                onDoubleTap: () async {
                  likes = await db.likeAPost(
                      user.uid, widget.post.uid, widget.post.id);
                  widget.post.likes = likes;
                  setState(() {
                    like = likedOrNot(user.uid, likes);
                    len = likes.length;
                    print("LIKE: " + like.toString());
                    likes.forEach((element) {
                      print("ELEMENT: " + element);
                    });
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.post.text,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4.0, 8.0, 8.0),
                      child: IconButton(
                        icon: like
                            ? Icon(
                                Icons.favorite,
                                size: 30,
                                color: Color(0xfffb3958),
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 30,
                              ),
                        onPressed: () async {
                          likes = await db.likeAndUnlikePost(
                              user.uid, widget.post.uid, widget.post.id);
                          widget.post.likes = likes;
                          setState(() {
                            like = likedOrNot(user.uid, likes);
                            len = likes.length;
                            likes.forEach((element) {
                              print("ELEMENT: " + element);
                            });
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsPage(
                                      postId: widget.post.id,
                                      postUser: widget.post.uid,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                        child: Icon(
                          Icons.comment,
                          size: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 8.0),
                      child: Icon(
                        Icons.share,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: saved.contains(widget.post.id)
                      ? Icon(
                          Icons.bookmark,
                          size: 30,
                        )
                      : Icon(
                          Icons.bookmark_border,
                          size: 30,
                        ),
                  onPressed: () async {
                    await db.addSavedPost(user.uid, widget.post);

                    setState(() {
                      if (saved.contains(widget.post.id)) {
                        saved.remove(widget.post.id);
                      } else {
                        saved.add(widget.post.id);
                      }
                    });
                  },
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FollowingPage(
                            followers: widget.post.likes,
                            uid: user.uid,
                            title: "Likes")));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 8.0),
                child: Text(
                  len == 1
                      ? len.toString() + " like"
                      : len.toString() + " likes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0, 8.0),
              child: Text(
                db.convertTime(widget.post.postTime),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
