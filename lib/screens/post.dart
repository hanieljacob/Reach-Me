import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/services/database.dart';
import 'home.dart';
import 'search.dart';
import 'dart:io';
import 'notifications.dart';
import 'account.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/upload.dart';

import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final int index;
  PostPage({this.index});
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Database db = Database();
  String uid;
  int numberOfPosts;
  int postNumber;
  int _selectedIndex = 2;
  File _image;
  final firestoreInstance = Firestore.instance;
  TextEditingController textEditingController = TextEditingController();

  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    final _picker = ImagePicker();

    PickedFile image = await _picker.getImage(source: source);
    final File file = File(image.path);

    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
      maxWidth: 512,
      maxHeight: 512,
    );

    //Compress the image

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      file.path,
      quality: 100,
    );

    setState(() {
      _image = result;
      print(_image.lengthSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.index;
    bool posted = false;
    var user = Provider.of<FirebaseUser>(context);
    uid = user.uid;
    return _selectedIndex == 2
        ? SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Create a post",
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(24),
                      child: new TextFormField(
                        maxLength: 200,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: "Post a thought...",
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(16.0),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        controller: textEditingController,
                      ),
                    ),
                    Center(
                      child: _image == null
                          ? SizedBox.shrink()
                          : Image.file(
                              _image,
                              height: 200,
                              width: 200,
                            ),
                    ),
                    if (posted) ...[
                      Center(
                        child: Text('Posted'),
                      ),
                    ],
                  ],
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton.extended(
                    label: Text("Camera"),
                    onPressed: () => getImageFile(ImageSource.camera),
                    heroTag: UniqueKey(),
                    icon: Icon(Icons.camera),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton.extended(
                    label: Text("Gallery"),
                    onPressed: () => getImageFile(ImageSource.gallery),
                    heroTag: UniqueKey(),
                    icon: Icon(Icons.photo_library),
                  ),
                  FloatingActionButton.extended(
                    label: Text("Post"),
                    onPressed: () async {
                      print("hello " + uid);
                      if (_image != null) {
                        var postCount = await db.getPostCount(uid);
                        Uploader uploader =
                            Uploader(file: _image, uid: uid, count: postCount);
                        var url = await uploader.startUpload();
                        await db.createNewPost(
                          uid,
                          textEditingController.text,
                          url,
                        );
                        if (url == null) {
                          setState(() {
                            posted = true;
                          });
                        }
                        print("CDE: " + uid);

//                firestoreInstance.collection("Users").document(Uid).collection(
//                    "Posts").document("Post 1").setData(
//                    {'Text': textEditingController.text});
                      }
                    },
                    heroTag: UniqueKey(),
                  )
                ],
              ),
            ),
        )
        : _selectedIndex == 0
            ? HomePage(
                index: widget.index,
              )
            : _selectedIndex == 1
                ? SearchPage(
                    index: widget.index,
                  )
                : _selectedIndex == 3
                    ? NotificationsPage(
                        index: widget.index,
                      )
                    : SettingsPage(
                        index: widget.index,
                      );
  }
}
