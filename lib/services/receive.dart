import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reach_me/firebase_auth.dart';

class Receive{
  Future<String> getData() async{
    final FirebaseStorage _firebaseStorage = FirebaseStorage(storageBucket: 'gs://reach-me-23758.appspot.com');
    final ref = _firebaseStorage.ref().child('posts').child(Uid).child('post1.png');
    print("ref"+ref.toString());
    String url = await ref.getDownloadURL() as String;
    print("url" + url);
    return url;
  }
}

