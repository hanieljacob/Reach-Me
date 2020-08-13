import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart';

class Database {
  CollectionReference userRef = Firestore.instance.collection("Users");
  Future createNewUserData(FirebaseUser user) async {
    if (await userRef.document(user.uid).get().then((value) => !value.exists)) {
      return await userRef.document(user.uid).setData({
        "uid": user.uid,
        "posts": [],
        "name": user.displayName,
        'userphoto': user.photoUrl,
      });
    }
  }

  Future getPostCount(String uid) async {
    List post;
    int postCount;
    await userRef
        .document(uid)
        .get()
        .then((value) => value.data.forEach((key, value) {
              if (key == "posts") {
                post = value;
                // print(post.length);
                postCount = post.length + 1;
              }
            }));
    print('Hello' + postCount.toString());
    return postCount;
  }

  Future getPosts(String uid) async {
    List post;
    await userRef
        .document(uid)
        .get()
        .then((value) => value.data.forEach((key, value) {
              if (key == "posts") {
                post = value;
              }
            }));
    // print('Hello' + postCount.toString());

    return post;
  }

  Future createNewPost(String uid, String text, String url) async {
    List post;
    // int postCount;
//    await userRef.document(uid).updateData({'posts':FieldValue.arrayUnion([{'text':text}])});
    userRef
        .document(uid)
        .get()
        .then((value) => value.data.forEach((key, value) {
              if (key == "posts") {
                post = value;
                post.add({
                  'text': text,
                  'photoUrl': url,
                });
                userRef.document(uid).updateData({'posts': post});
                // print(post.length);
                // postCount = post.length;
              }
            }));
    // return postCount;
  }

  User createUser(String name, String uid, String photourl, List posts) {
    return User(
      name: name,
      uid: uid,
      photoUrl: photourl,
      posts: posts,
    );
  }

  Future getUsers() async {
    List<User> users = [];
    var result = await userRef.getDocuments();
    result.documents.forEach((element) {
      users.add(
        createUser(
            element.data['name'],
            element.data['uid'],
            element.data['userphoto'],
            element.data['posts']),
      );
    });
    users.forEach((element) {
      print(element.name);
    });
    return users;
  }
}
