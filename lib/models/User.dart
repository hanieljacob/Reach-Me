class User {
  String name;
  String photoUrl;
  List posts;
  String uid;
  List followers;
  List following;
  List requests;
  List requested;
  User({
    this.name,
    this.photoUrl,
    this.posts,
    this.uid,
    this.followers,
    this.following,
    this.requests,
    this.requested,
  });
}
