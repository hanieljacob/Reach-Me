import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Database{
  CollectionReference userRef = Firestore.instance.collection("Users");
  Future createNewUserData(FirebaseUser user) async{
    if(await userRef.document(user.uid).get().then((value) => !value.exists)){
      return await userRef.document(user.uid).setData({"uid":user.uid,"posts":[],"name":user.displayName});
    }
  }

  Future createNewPost(String uid, String text, String url) async{
    List post;
    int length;
//    await userRef.document(uid).updateData({'posts':FieldValue.arrayUnion([{'text':text}])});
    await userRef.document(uid).get().then((value) => value.data.forEach((key, value) {
      if(key == "posts"){
        post = value;
        post.add({'text':text,'postURL':url});
        userRef.document(uid).updateData({'posts':post});
        length = post.length;
      }
    }));
//    print("DBLen: "+length.toString());
    return length;
  }

  Future noOfPost(String uid) async{
    List post;
    int length;
//    await userRef.document(uid).updateData({'posts':FieldValue.arrayUnion([{'text':text}])});
    await userRef.document(uid).get().then((value) => value.data.forEach((key, value) {
      if(key == "posts"){
        post = value;
        length = post.length;
      }
    }));
//    print("DBLen: "+length.toString());
    return length;
  }
}