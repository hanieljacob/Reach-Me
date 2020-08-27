import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';

class Uploader {
  int postNumber;
  final File file;
  String uid;
  int count;
  Uploader({Key key, this.file, this.uid, this.count});
  final FirebaseStorage _firebaseStorage =
      FirebaseStorage(storageBucket: 'gs://reach-me-23758.appspot.com');
  StorageUploadTask _storageUploadTask;
  String path;
  var task;

  Future<String> startUpload() async {
//    firestoreInstance.collection("Users").document(Uid)
    String filePath = 'posts/$uid/post$count.png';
    _storageUploadTask = _firebaseStorage.ref().child(filePath).putFile(file);
    task = await _storageUploadTask.onComplete;
    var url = await task.ref.getDownloadURL();
    print('Mine' + url);
    return url;
  }

}
