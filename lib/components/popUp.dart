//import 'package:flutter/material.dart';
//import 'package:reach_me/services/database.dart';
//class PopUp extends StatefulWidget {
//  final String postUser;
//  final String postId;
//  final BuildContext context;
//  PopUp({this.postUser,this.postId, this.context});
//  @override
//  _PopUpState createState() => _PopUpState();
//}
//
////class _PopUpState extends State<PopUp> {
////  Database db = Database();
////  @override
////  Widget build(BuildContext context) {
////    return showDialog( context: widget.context,
////      builder: (BuildContext context){
////        return AlertDialog(
////          content: Column(
////            children: <Widget>[
////              ListTile(
////                title: Text(
////                    'Delete'
////                ),
////                onTap:(){
////                  db.deletePost(widget.postUser, widget.postId);
////                },
////              ),
////            ],
////          ),
////        );
////      }
////    );
////  }
////}
