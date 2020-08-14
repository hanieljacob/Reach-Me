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
        'followers': [],
        'following': [],
        'requests' : [],
      });
    }
  }

  Future addFollower(String uid1, String uid2) async{
    List request;
    userRef
        .document(uid2)
        .get()
        .then((value) => value.data.forEach((key, value) {
      if (key == "requests") {
        request = value;
        request.add(
          uid1
        );
        userRef.document(uid2).updateData({'requests': request});
        // print(post.length);
        // postCount = post.length;
      }
    }));
  }

  Future getRequest(String uid) async{
    List requests = [];
    await userRef.document(uid).get().then((value) => value.data.forEach((key, value){
      if(key == 'requests')
        requests = value;
    }));
    return requests;
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

  User createUser(String name, String uid, String photourl, List posts, List followers, List following, List requests) {
    return User(
      name: name,
      uid: uid,
      photoUrl: photourl,
      posts: posts,
      followers: followers,
      following: following,
      requests: requests,
    );
  }

  Future getRequestedUser(String uid) async{
    List<User> users = [];
    List<User> requestedUsers = [];
    User currentUser;
    var result = await userRef.getDocuments();
    result.documents.forEach((element) {
        if(element.data['uid']==uid){
          currentUser = createUser(
            element.data['name'],
            element.data['uid'],
            element.data['userphoto'],
            element.data['posts'],
            element.data['followers'],
            element.data['following'],
            element.data['requests'],
          );
        }
        users.add(
          createUser(
            element.data['name'],
            element.data['uid'],
            element.data['userphoto'],
            element.data['posts'],
            element.data['followers'],
            element.data['following'],
            element.data['requests'],
          ),
        );
    }
    );
    currentUser.requests.forEach((element) {
      users.forEach((value) {
        if(element == value.uid){
          requestedUsers.add(value);
        }
      });
    });
    print(requestedUsers);
  }

  Future getUsers(var userUid) async {
    List<User> users = [];
    var result = await userRef.getDocuments();
    result.documents.forEach((element) {
      if(userUid != element.documentID) {
        users.add(
          createUser(
              element.data['name'],
              element.data['uid'],
              element.data['userphoto'],
              element.data['posts'],
              element.data['followers'],
              element.data['following'],
              element.data['requests'],
          ),

        );
      }
    });
    users.forEach((element) {
      print(element.name);
    });
    return users;
  }
}
