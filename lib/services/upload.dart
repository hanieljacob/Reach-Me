import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'receive.dart';


class Uploader{
  int postNumber;
  final File file;
  String uid;
  Uploader({Key key,this.file,this.uid});
  final FirebaseStorage _firebaseStorage = FirebaseStorage(storageBucket: 'gs://reach-me-23758.appspot.com');
  StorageUploadTask _storageUploadTask;
  String path;

  void startUpload(){
//    firestoreInstance.collection("Users").document(Uid)
    String filePath = 'posts/$uid/post1.png';
    _storageUploadTask = _firebaseStorage.ref().child(filePath).putFile(file);
  }
}
