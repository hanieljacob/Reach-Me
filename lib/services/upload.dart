import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'receive.dart';


class Uploader{
  int postNumber;
  final File file;
  String uid;
  String url;
  Uploader({Key key,this.file,this.uid});
  final FirebaseStorage _firebaseStorage = FirebaseStorage(storageBucket: 'gs://reach-me-23758.appspot.com');
  StorageUploadTask _storageUploadTask;
  String path;

  Future startUpload(int len) async{
//    firestoreInstance.collection("Users").document(Uid)
    print(len);
    String filePath = 'posts/$uid/post$len.png';
    _storageUploadTask = _firebaseStorage.ref().child(filePath).putFile(file);
    url = await _firebaseStorage.ref().child('posts').child(uid).child('post$len.png').getDownloadURL() as String;
    print(url);
    return url;
  }
}
