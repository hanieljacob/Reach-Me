import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reach_me/models/Message.dart';

import 'package:reach_me/models/Post.dart';
import '../models/User.dart';

class Database {
  CollectionReference userRef = Firestore.instance.collection("Users");
  CollectionReference msgRef = Firestore.instance.collection("Messages");
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  final FirebaseStorage _firebaseStorage =
  FirebaseStorage(storageBucket: 'gs://reach-me-23758.appspot.com');
  StorageUploadTask _storageUploadTask;

  User createUser(
      String name,
      String uid,
      String photourl,
      List posts,
      List followers,
      List following,
      List requests,
      List requested,
      List saved) {
    return User(
      name: name,
      uid: uid,
      photoUrl: photourl,
      posts: posts,
      followers: followers,
      following: following,
      requests: requests,
      requested: requested,
      saved: saved,
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
        'saved': [],
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
            element.data['saved'],
          ),
        );
      }
    });
    users.forEach((element) {
      print(element.name);
    });
    return users;
  }

  Future<User> getUser(var userUid) async {
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
          element.data['saved'],
        );
      }
    });
    return user;
  }

  Future addSavedPost(String uid, Post post) async {
    List savedPosts = [];
    List savesId = [];
    Map posts = {
      'id': post.id,
      'text': post.text,
      'photoUrl': post.photoUrl,
      'comments': post.comments,
      'postTime': post.postTime,
      'likes': post.likes,
      'username': post.username,
      'uid': post.uid,
      'userphoto': post.userphoto
    };
    userRef.document(uid).get().then((value) {
      savedPosts = value.data['saved'];
      savedPosts.forEach((element) {
        savesId.add(element['id']);
      });
      if (savesId.contains(post.id)) {
        removeSavedPost(uid, post.id);
        savesId.remove(post.id);
      } else {
        userRef.document(uid).updateData({
          'saved': FieldValue.arrayUnion([posts])
        });
        savesId.add(post.id);
      }
    });
    return savesId;
  }

  void removeSavedPost(String uid, String postId) async {
    List posts = [];
    List posts2 = [];
    userRef.document(uid).get().then((value) {
      posts = value.data['saved'];
      posts.forEach((element) {
        if (element['id'] != postId) {
          posts2.add(element);
        }
      });
      userRef.document(uid).updateData({'saved': posts2});
    });
  }

  Future getSavedPost(String uid) async {
    List<Post> post = [];
    List posts = [];
    await userRef.document(uid).get().then((value) {
      posts = value.data['saved'];
    });
    posts.forEach((element) {
      post.add(
        createNewPostData(
            element['text'],
            element['photoUrl'],
            element['comments'],
            element['likes'],
            element['postTime'],
            element['uid'],
            element['userphoto'],
            element['username'],
            element['id']),
      );
    });
    return post;
  }

  Future getSavedPostId(String uid) async {
    List post = [];
    List posts = [];
    await userRef.document(uid).get().then((value) {
      posts = value.data['saved'];
    });
    posts.forEach((element) {
      post.add(element['id']);
    });
    print(post);
    return post;
  }

  Post createNewPostData(
      String text,
      String photoUrl,
      List comments,
      List likes,
      Timestamp postTime,
      String uid,
      String userphoto,
      String username,
      String id) {
    return Post(
        text: text,
        photoUrl: photoUrl,
        comments: comments,
        likes: likes,
        postTime: postTime,
        uid: uid,
        username: username,
        userphoto: userphoto,
        id: id);
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
              userData[ind]['username'],
              element['id']),
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
              userData['username'],
              element['id']),
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
                  'id': getRandomString(15),
                });
                userRef.document(uid).updateData({'posts': post});
                // print(post.length);
                // postCount = post.length;
              }
            }));
    // return postCount;
  }

  Future likeAndUnlikePost(
      String currentUser, String postUser, String id) async {
    List post = [];
    List likes = [];
    Map posts;
    bool isLiked;
    post = await getPosts(postUser);
    post.forEach((element) {
      if (element['id'] == id) {
        if (element['likes'].contains(currentUser)) {
          element['likes'].remove(currentUser);
          isLiked = false;
        } else {
          element['likes'].add(currentUser);
          isLiked = true;
        }
        posts = element;
      }
    });
    userRef.document(postUser).updateData({'posts': post});
    return posts['likes'];
  }

  Future likeAPost(String currentUser, String postUser, String id) async {
    List post = [];
    List likes = [];
    Map posts;
    bool isLiked;
    post = await getPosts(postUser);
    post.forEach((element) {
      if (element['id'] == id) {
        if (element['likes'].contains(currentUser)) {
        } else {
          element['likes'].add(currentUser);
          isLiked = true;
        }
        posts = element;
      }
    });
    userRef.document(postUser).updateData({'posts': post});
    return posts['likes'];
  }

  Future getLikedUsers(List uid) async {
    List users = [];
    var result = await userRef.getDocuments();
    result.documents.forEach((element) {
      if (uid.contains(element.documentID)) {
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
            element.data['saved'],
          ),
        );
      }
    });
    users.forEach((element) {
      print(element.name);
    });
    return users;
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
          element.data['saved'],
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
          element.data['saved'],
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

  Future addComment(
      String curUser, String postUser, String comment, String postID) async {
    List post = [];
    Map comments;
    User user;
    post = await getPosts(postUser);
    user = await getUser(curUser);
    post.forEach((element) {
      if (element['id'] == postID) {
        comments = {
          'user': curUser,
          'comment': comment,
          'time': Timestamp.now(),
          'userPic': user.photoUrl,
          'username': user.name
        };
        element['comments'].add(comments);
      }
    });
    userRef.document(postUser).updateData({
      'posts': post,
    });
  }

  Future getComments(String postUser, String postID) async {
    List post = [];
    List comments = [];
    post = await getPosts(postUser);
    post.forEach((element) {
      if (element['id'] == postID) {
        comments = element['comments'];
      }
    });
    print(comments);
    return comments;
  }

  String convertTime(Timestamp timestamp) {
    Timestamp currentTimestamp = Timestamp.now();
    int diff = currentTimestamp.millisecondsSinceEpoch -
        timestamp.millisecondsSinceEpoch;
    double diff1;
    String time;
    if (diff > 60000 * 60 * 24 * 365) {
      diff1 = diff / (60000 * 60 * 24 * 365);
      if (diff1.toStringAsFixed(0) == "1") {
        time = diff1.toStringAsFixed(0) + " year ago";
      } else
        time = diff1.toStringAsFixed(0) + " years ago";
    } else if (diff > 60000 * 60 * 24) {
      diff1 = diff / (60000 * 60 * 24);
      if (diff1.toStringAsFixed(0) == "1") {
        time = diff1.toStringAsFixed(0) + " day ago";
      } else
        time = diff1.toStringAsFixed(0) + " days ago";
    } else if (diff >= 60000 * 60) {
      diff1 = diff / (60000 * 60);
      if (diff1.toStringAsFixed(0) == "1") {
        time = diff1.toStringAsFixed(0) + " hour ago";
      } else
        time = diff1.toStringAsFixed(0) + " hours ago";
    } else if (diff >= 60000) {
      diff1 = diff / 60000;
      if (diff1.toStringAsFixed(0) == "1") {
        time = diff1.toStringAsFixed(0) + " minute ago";
      } else
        time = diff1.toStringAsFixed(0) + " minutes ago";
    } else {
      diff1 = diff / 1000;
      if (diff1.toStringAsFixed(0) == "1") {
        time = diff1.toStringAsFixed(0) + " second ago";
      } else
        time = diff1.toStringAsFixed(0) + " seconds ago";
    }
    return (time);
  }

  Future chatImageUpload({String chatId, File file, String fromUid, String toUid}) async{
    var task;
    String time = Timestamp.now().millisecondsSinceEpoch.toString();
    String filePath = 'chat/$chatId/$time.png';
    _storageUploadTask = _firebaseStorage.ref().child(filePath).putFile(file);
    task = await _storageUploadTask.onComplete;
    var url = await task.ref.getDownloadURL();
    print('Mine' + url);
    msgRef.document(chatId).collection(chatId).document(time).setData({
      'content': url,
      'fromUid': fromUid,
      'toUid': toUid,
      'time': time,
      'type': 1,
    });
  }


  Future deletePost(String postUser, String postId) async {
    List posts = [];
    List posts2 = [];
    posts = await getPosts(postUser);
    posts.forEach((element) {
      if (postId != element['id']) {
        posts2.add(element);
      }
    });
    userRef.document(postUser).updateData({'posts': posts2});
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

  Message createMessage(
      String content, String fromUid, String toUid, String time, int type) {
    return Message(
        content: content,
        fromUid: fromUid,
        time: time,
        toUid: toUid,
        type: type);
  }

  Future sendMessage(String fromUid, String toUid, String content, int type,
      String chatId) async {
    String time = Timestamp.now().millisecondsSinceEpoch.toString();
    msgRef.document(chatId).collection(chatId).document(time).setData({
      'content': content,
      'fromUid': fromUid,
      'toUid': toUid,
      'time': time,
      'type': type,
    });
  }
}
