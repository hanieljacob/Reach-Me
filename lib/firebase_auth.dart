import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/post.dart';

class AuthProvider{

  AuthResult res;
  GoogleSignInAccount account;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = Firestore.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> signInWithEmail(String email, String password) async{
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if(user != null)
        return true;
      else
        return false;
    }
    catch(err){
      return false;
    }
  }


  Future<void> logout() async{
    try {
      googleSignIn.disconnect();
      await _auth.signOut();
    }
    catch(e){
      print("Error logging out");
    }
  }

  Future<bool> loginWithGoogle() async{
    try{
      account = await googleSignIn.signIn();
      PostPage postPage = PostPage();

      if(account == null)
        return false;
      res = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: (await account.authentication).idToken, accessToken: (await account.authentication).accessToken));
      firestoreInstance.collection("Users").document(res.user.uid).setData({});
      postPage.getRes(res.user.uid);
      if(res.user==null)
        return false;
      else
        return true;
    }catch(e){
      print(e);
      return false;
    }
  }
}