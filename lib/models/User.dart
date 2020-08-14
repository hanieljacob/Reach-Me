class User {
  String name;
  String photoUrl;
  List posts;
  String uid;
  List<String> followers;
  List<String> following;
  List<String> requests;
  User({this.name, this.photoUrl, this.posts, this.uid, this.followers, this.following, this.requests});
}
