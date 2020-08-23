import 'package:flutter/material.dart';
import 'package:reach_me/components/PostCard.dart';
import 'package:reach_me/models/Post.dart';
import 'package:reach_me/services/database.dart';

class SavedPostsPage extends StatefulWidget {
  final String uid;
  SavedPostsPage({this.uid});
  @override
  _SavedPostsPageState createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  Database db = Database();
  List<Post> posts = [];
  @override
  void initState() {
    super.initState();
    getSavedPosts(widget.uid);
  }

  void getSavedPosts(String uid){
    db.getSavedPost(uid).then((value) => setState((){
      posts = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Posts'
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return posts.length == 0
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Text('No Post'),
                    ),
                  )
                      : PostCard(
                    post: posts[index],
                    accountsPage: false,
                  );
                }, childCount: posts.length == 0 ? 1 : posts.length),
          )
        ],
      ),
    );
  }
}
