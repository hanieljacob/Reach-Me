import 'package:firebase_storage/firebase_storage.dart';

class Receive {
  Future<String> getData(String uid) async {
    final FirebaseStorage _firebaseStorage =
        FirebaseStorage(storageBucket: 'gs://reach-me-23758.appspot.com');
    final ref =
        _firebaseStorage.ref().child('posts').child(uid).child('post1.png');
    print("ref" + ref.toString());
    String url = await ref.getDownloadURL() as String;
    print("url" + url);
    return url;
  }
}
