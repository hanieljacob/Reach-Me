import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reach_me/models/Post.dart';
import '../models/User.dart';

class Database {
  CollectionReference userRef = Firestore.instance.collection("Users");

  User createUser(
    String name,
    String uid,
    String photourl,
    List posts,
    List followers,
    List following,
    List requests,
    List requested,
  ) {
    return User(
      name: name,
      uid: uid,
      photoUrl: photourl,
      posts: posts,
      followers: followers,
      following: following,
      requests: requests,
      requested: requested,
    );
  }

  Future createNewUserData(FirebaseUser user) async {
    if (await userRef.document(user.uid).get().then((value) => !value.exists)) {
      return await userRef.document(user.uid).setData({
        "uid": user.uid,
        "posts": [],
        "name": user.displayName,
        'userphoto': user.photoUrl,
        'followers': [],
        'following': [],
        'requests': [],
        'requested': [],
      });
    }
  }

  Future getUsers(var userUid) async {
    List<User> users = [];
    var result = await userRef.getDocuments();
    result.documents.forEach((element) {
      if (userUid != element.documentID) {
        users.add(
          createUser(
            element.data['name'],
            element.data['uid'],
            element.data['userphoto'],
            element.data['posts'],
            element.data['followers'],
            element.data['following'],
            element.data['requests'],
            element.data['requested'],
          ),
        );
      }
    });
    users.forEach((element) {
      print(element.name);
    });
    return users;
  }

  Future getUser(var userUid) async {
    User user;
    var result = await userRef.getDocuments();
    result.documents.forEach((element) {
      if (userUid == element.documentID) {
        user = createUser(
          element.data['name'],
          element.data['uid'],
          element.data['userphoto'],
          element.data['posts'],
          element.data['followers'],
          element.data['following'],
          element.data['requests'],
          element.data['requested'],
        );
      }
    });
    return user;
  }

  Post createNewPostData(
      String text,
      String photoUrl,
      List comments,
      List likes,
      Timestamp postTime,
      String uid,
      String userphoto,
      String username) {
    return Post(
        text: text,
        photoUrl: photoUrl,
        comments: comments,
        likes: likes,
        postTime: postTime,
        uid: uid,
        username: username,
        userphoto: userphoto);
  }

  Future getPostData(String uid) async {
    List<Post> posts = [];
    List rawPost = [];
    List following = [];
    List userData = [];
    int ind = 0;

    var result = await userRef.getDocuments();
    await userRef.document(uid).get().then((value) {
      following = value.data['following'];

      result.documents.forEach((element) {
        if (following.contains(element.data['uid']) ||
            element.data['uid'] == uid) {
          for (int i = 0; i < element.data['posts'].length; i++)
            userData.add({
              'username': element.data['name'],
              'uid': element.data['uid'],
              'userphoto': element.data['userphoto'],
            });
          rawPost.add(element.data['posts']);
        }
      });
    });
    print(userData);

    rawPost.forEach((element) {
      List post = element;
      post.forEach((element) {
        posts.add(
          createNewPostData(
              element['text'],
              element['photoUrl'],
              element['comments'],
              element['likes'],
              element['postTime'],
              userData[ind]['uid'],
              userData[ind]['userphoto'],
              userData[ind]['username']),
        );
        ind++;
      });
    });
    posts.forEach((element) {
      print(element.username + " " + element.text);
    });
    posts.sort((a, b) {
      var date1 = new DateTime.fromMillisecondsSinceEpoch(
          a.postTime.millisecondsSinceEpoch * 1000);
      var date2 = new DateTime.fromMillisecondsSinceEpoch(
          b.postTime.millisecondsSinceEpoch * 1000);
      return date2.compareTo(date1);
    });
//    print(posts[0].username);
//    posts.forEach((element) {
//      print(element.username+" "+element.text);
//   });
    return posts;
//    print(rawPost);
  }

  Future userPostData(String uid) async {
    List<Post> posts = [];
    List rawPost = [];
    var userData;

    await userRef.document(uid).get().then((value) {
      userData = {
        'username': value.data['name'],
        'uid': value.data['uid'],
        'userphoto': value.data['userphoto'],
      };
      rawPost.add(value.data['posts']);
    });
    print("MMM: " + rawPost.toString());

    rawPost.forEach((element) {
      List post = element;
      post.forEach((element) {
        posts.add(
          createNewPostData(
              element['text'],
              element['photoUrl'],
              element['comments'],
              element['likes'],
              element['postTime'],
              userData['uid'],
              userData['userphoto'],
              userData['username']),
        );
      });
    });
    posts.sort((a, b) {
      var date1 = new DateTime.fromMillisecondsSinceEpoch(
          a.postTime.millisecondsSinceEpoch * 1000);
      var date2 = new DateTime.fromMillisecondsSinceEpoch(
          b.postTime.millisecondsSinceEpoch * 1000);
      return date2.compareTo(date1);
    });
    print(posts[0].username);
    posts.forEach((element) {
      print(element.username + " " + element.text);
    });

    return posts;
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
                  'comments': [],
                  'likes': [],
                  'postTime': DateTime.now(),
                  'id': post.length + 1,
                });
                userRef.document(uid).updateData({'posts': post});
                // print(post.length);
                // postCount = post.length;
              }
            }));
    // return postCount;
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

  Future createRequest(String curUserUid, String reqUserUid) async {
    // List request;
    userRef.document(reqUserUid).updateData({
      'requests': FieldValue.arrayUnion([curUserUid])
    });
    userRef.document(curUserUid).updateData({
      'requested': FieldValue.arrayUnion([reqUserUid])
    });
    // userRef
    //     .document(uid2)
    //     .get()
    //     .then((value) => value.data.forEach((key, value) {
    //           if (key == "requests") {
    //             request = value;
    //             request.add(uid1);
    //             userRef.document(uid2).updateData({'requests': request});
    //             // print(post.length);
    //             // postCount = post.length;
    //           }
    //         }));
  }

  Future getRequestedUser(List requests) async {
    List<User> users = [];
    List<User> reqUsers = [];
    var result = await userRef.getDocuments();
    result.documents.forEach((element) {
      users.add(
        createUser(
          element.data['name'],
          element.data['uid'],
          element.data['userphoto'],
          element.data['posts'],
          element.data['followers'],
          element.data['following'],
          element.data['requests'],
          element.data['requested'],
        ),
      );
    });
    users.forEach((element) {
      if (requests.contains(element.uid)) {
        reqUsers.add(element);
      }
    });
    return reqUsers;
  }

  Future getFollowers(List followers) async {
    List<User> users = [];
    List<User> follower = [];
    var result = await userRef.getDocuments();
    result.documents.forEach((element) {
      users.add(
        createUser(
          element.data['name'],
          element.data['uid'],
          element.data['userphoto'],
          element.data['posts'],
          element.data['followers'],
          element.data['following'],
          element.data['requests'],
          element.data['requested'],
        ),
      );
    });
    users.forEach((element) {
      if (followers.contains(element.uid)) {
        follower.add(element);
      }
    });
    return follower;
  }

  Future getRequest(String uid) async {
    List requests = [];
    await userRef
        .document(uid)
        .get()
        .then((value) => value.data.forEach((key, value) {
              if (key == 'requests') requests = value;
            }));
    return requests;
  }

  Future addFollowerAndFollowing(String curUser, String reqUser) async {
    //add followers to current users and add following to requested to user
    userRef.document(curUser).updateData({
      'followers': FieldValue.arrayUnion([reqUser])
    });
    userRef.document(reqUser).updateData({
      'following': FieldValue.arrayUnion([curUser])
    });
    print(reqUser);
    print(curUser);
    //remove requests from current users and remove requested from requested user
    userRef.document(curUser).updateData({
      'requests': FieldValue.arrayRemove([reqUser])
    });
    userRef.document(reqUser).updateData({
      'requested': FieldValue.arrayRemove([curUser])
    });
  }

  Future disconnect(String curUser, String reqUser) async {
    userRef.document(curUser).updateData({
      'followers': FieldValue.arrayRemove([reqUser])
    });

    userRef.document(reqUser).updateData({
      'following': FieldValue.arrayRemove([curUser])
    });
  }

  Future unfollow(String curUser, String reqUser) async {
    userRef.document(curUser).updateData({
      'following': FieldValue.arrayRemove([reqUser])
    });

    userRef.document(reqUser).updateData({
      'followers': FieldValue.arrayRemove([curUser])
    });
  }
}
