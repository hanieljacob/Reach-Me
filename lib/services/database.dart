import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Database{
  CollectionReference userRef = Firestore.instance.collection("Users");
  Future createNewUserData(FirebaseUser user) async{
    if(await userRef.document(user.uid).get().then((value) => !value.exists)){
      return await userRef.document(user.uid).setData({"uid":user.uid,"posts":[],"name":user.displayName});
    }
  }

  Future createNewPost(String uid, String text) async{
    List post;
//    await userRef.document(uid).updateData({'posts':FieldValue.arrayUnion([{'text':text}])});
    userRef.document(uid).get().then((value) => value.data.forEach((key, value) {
      if(key == "posts"){
        post = value;
        post.add({'text':text});
        userRef.document(uid).updateData({'posts':post});
        print(post.length);
      }
    }));
  }
}