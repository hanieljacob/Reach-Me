import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/firebase_auth.dart';
import 'package:reach_me/screens/saved.dart';

class AccountDrawer extends StatefulWidget {
  @override
  _AccountDrawerState createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
  AuthProvider _authProvider = AuthProvider();
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Container(
      width: MediaQuery.of(context).size.width/1.5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Edit'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.bookmark_border),
              title: Text('Saved Posts'),
              onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) =>
              SavedPostsPage(uid: user.uid)
              ))},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => {
                _authProvider.logout()
              },
            ),
          ],
        ),
      ),
    );
  }
}

