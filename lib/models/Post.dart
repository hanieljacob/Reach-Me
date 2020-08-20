import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  String text;
  String photoUrl;
  List comments;
  Timestamp postTime;
  List likes;
  String username;
  String uid;
  String userphoto;
  String id;
  Post({this.text,this.photoUrl,this.comments,this.likes,this.postTime,this.uid,this.username,this.userphoto,this.id});
}