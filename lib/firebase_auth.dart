import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';

import './services/database.dart';

//String Uid;
class AuthProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Database db = Database();
  AuthResult res;
  GoogleSignInAccount account;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = Firestore.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user != null)
        return true;
      else
        return false;
    } catch (err) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await googleSignIn.disconnect().whenComplete(() async {
        await _auth.signOut();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      LocationData location = await Location().getLocation();
      account = await googleSignIn.signIn();
      // PostPage postPage = PostPage();

      if (account == null) return false;
      res = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: (await account.authentication).idToken,
          accessToken: (await account.authentication).accessToken));
      db.createNewUserData(res.user, await _firebaseMessaging.getToken(),
          location.latitude, location.longitude);
//      firestoreInstance.collection("Users").document(res.user.uid).setData({});
//      Uid = res.user.uid;
//      postPage.storeUserId(res.user.uid);
      if (res.user == null)
        return false;
      else
        return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  String getUserId() {
    print("Hello" + res.user.uid);
    return res.user.uid;
  }
}
