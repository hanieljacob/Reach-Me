import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/components/loading.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/services/database.dart';

class CreateGroup extends StatefulWidget {
  final User user;
  final List<String> selectedUids;
  CreateGroup({this.user, this.selectedUids});
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  Database db = Database();
  TextEditingController _controller = TextEditingController();
  File _image;
  bool loading = false;
  String url;
  var docs;
  bool validate = false;

  final FirebaseStorage _firebaseStorage =
      FirebaseStorage(storageBucket: 'gs://reach-me-23758.appspot.com');
  StorageUploadTask _storageUploadTask;

  void startUpload(File file) async {
    String filepath = 'group/${DateTime.now()}.png';
    _storageUploadTask = _firebaseStorage.ref().child(filepath).putFile(file);
    var task = await _storageUploadTask.onComplete;
    var url2 = await task.ref.getDownloadURL();
    setState(() {
      loading = false;
      url = url2;
    });
  }

  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    final _picker = ImagePicker();

    PickedFile image = await _picker.getImage(source: source);
    final File file = File(image.path);

    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
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
      startUpload(_image);
      loading = true;
      print(_image.lengthSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.group_add),
          onPressed: () {
            if (_controller.text.trimLeft() != '' &&
                _controller.text.isNotEmpty) {
              db.createGroup(
                  widget.user.uid,
                  widget.selectedUids,
                  _controller.text,
                  url ??
                      'https://sdg4a.org/wp-content/plugins/profilegrid-user-profiles-groups-and-communities/public/partials/images/default-group.jpg');
              int count = 0;
              Navigator.of(context).popUntil((route) => count++ == 2);
            } else
              setState(() {
                validate = true;
              });
          }),
      appBar: AppBar(
        title: Text('Create New Group'),
      ),
      body: loading
          ? Loading()
          : StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  docs = snapshot.data.documents;
                  print(snapshot.data.documents[0]['uid']);
                }
                return !snapshot.hasData
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                                child: RawMaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    getImageFile(ImageSource.gallery);
                                  },
                                  fillColor:
                                      url == null ? Colors.blue : Colors.white,
                                  child: url == null
                                      ? Icon(
                                          Icons.camera_alt,
                                          size: 28.0,
                                          color: Colors.white,
                                        )
                                      : CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(url),
                                        ),
                                  padding: EdgeInsets.all(13.0),
                                  shape: CircleBorder(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFormField(
                                    controller: _controller,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                    cursorColor: Colors.blue,
                                    decoration: new InputDecoration(
                                        errorText: validate
                                            ? 'Please Enter a group name'
                                            : null,
                                        contentPadding: EdgeInsets.only(
                                            left: 8, top: 11, right: 15),
                                        hintText: "Group Name"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              children: [
                                Text(
                                  "Members: " +
                                      widget.selectedUids.length.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                print(widget.selectedUids);
                                return widget.selectedUids
                                        .contains(docs[index]['uid'])
                                    ? ListTile(
                                        title: Text(
                                          docs[index]['name'],
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              docs[index]['userphoto']),
                                        ),
                                        trailing: widget.user.uid ==
                                                docs[index]['uid']
                                            ? Text('Admin')
                                            : SizedBox.shrink(),
                                      )
                                    : SizedBox.shrink();
                              },
                              itemCount: docs.length,
                            ),
                          ),
                        ],
                      );
              }),
    );
  }
}
