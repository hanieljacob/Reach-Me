import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/components/popUp.dart';
import 'package:reach_me/models/Post.dart';
import 'package:reach_me/screens/FollowingPage.dart';
import 'package:reach_me/screens/comments.dart';
import 'package:reach_me/services/database.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool accountsPage;
  PostCard({this.post,@required this.accountsPage});
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int len = 0;
  bool like = false;
  Database db = Database();

  bool LikedOrNot(String uid,List likes){
    bool isLiked = likes.contains(uid);
    return isLiked;
  }

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    List likes = [];
    if(firstTime){
      print("FT: "+widget.post.likes.toString());
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
                  padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                  child: Text(
                    widget.post.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if(widget.accountsPage)...[Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () async{
//                      PopUp(context: context, postUser: user.uid, postId: widget.post.id);
                    },
                    icon: Icon(
                      Icons.more_vert
                    ),
                  ),
                ),]
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0,0,8.0,8.0),
              child: GestureDetector(
                child: Image.network(widget.post.photoUrl,fit: BoxFit.cover,
                  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ?
                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
                onDoubleTap: () async{
                  likes = await db.likeAPost(user.uid, widget.post.uid, widget.post.id);
                  widget.post.likes = likes;
                  setState(() {
                    like = LikedOrNot(user.uid,likes);
                    len = likes.length;
                    print("LIKE: "+like.toString());
                    likes.forEach((element) {
                      print("ELEMENT: "+element);
                    });
                  });
                },
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.post.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.post.text,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,4.0,8.0,8.0),
                  child: IconButton(
                    icon: like?Icon(
                      Icons.favorite,
                      size: 30,
                      color: Color(0xfffb3958),
                    ):Icon(
                      Icons.favorite_border,
                      size: 30,
                    ),
                    onPressed: () async{
//                          print(widget.post.likes);
//                          db.likeAndUnlikePost(user.uid, widget.post.uid, widget.post.id).then((value) => setState((){
//                            i++;
//                            print(value);
//                            isLiked = value;
//                          }));
                      likes = await db.likeAndUnlikePost(user.uid, widget.post.uid, widget.post.id);
                      widget.post.likes = likes;
                      setState(() {
                        like = LikedOrNot(user.uid,likes);
                        len = likes.length;
                        likes.forEach((element) {
                          print("ELEMENT: "+element);
                        });
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(postId: widget.post.id,postUser: widget.post.uid,)));},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,4.0,8.0,8.0),
                    child: Icon(
                      Icons.comment,
                      size: 30,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0,4.0,8.0,8.0),
                  child: Icon(
                    Icons.share,
                    size: 30,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => FollowingPage(followers: widget.post.likes,uid: user.uid,title: "Likes")));},
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0,0,0,8.0),
                child: Text(
                    len==1?len.toString()+" like":len.toString()+" likes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0,8.0,0,8.0),
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
