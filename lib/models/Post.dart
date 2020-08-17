import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  String text;
  String photoUrl;
  List comments;
  Timestamp postTime;
  List likes;
  Post({this.text,this.photoUrl,this.comments,this.likes,this.postTime});
}