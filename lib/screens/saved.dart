import 'package:flutter/material.dart';

class SavedPostsPage extends StatefulWidget {
  @override
  _SavedPostsPageState createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Posts'
        ),
      ),
    );
  }
}
