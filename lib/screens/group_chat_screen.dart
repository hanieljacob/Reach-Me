import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/components/loading.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/services/database.dart';

class GroupChatScreen extends StatefulWidget {
  final DocumentSnapshot doc;
  final User user;
  GroupChatScreen({this.user, this.doc});
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  Database db = Database();
  TextEditingController _controller = TextEditingController();
  File _image;
  String text;

  getImageFile() async {
    //Clicking or Picking from Gallery

    final _picker = ImagePicker();

    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    final File file = File(image.path);

    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square
      ],
      maxWidth: 512,
      maxHeight: 512,
    );

    //Compress the image

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      file.path,
      quality: 100,
    );

    db.groupChatImageUpload(
        chatId: widget.doc.documentID,
        fromUid: widget.user.uid,
        file: result,
        name: widget.user.name);

    setState(() {
      _image = result;
      print(_image.lengthSync());
    });
  }

  String timeFormat(int millisec) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisec);
    int hour = date.hour;
    int currentMili = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0, 0)
        .millisecondsSinceEpoch;
    String appendedTime = '';
    int difference = millisec - currentMili;
    print(difference);
    if (difference >= 0)
      appendedTime = 'Today @ ';
    else if (difference < 0 && difference >= -60000 * 60 * 24)
      appendedTime = 'Yesterday @ ';
    else {
      if (date.month >= 10)
        appendedTime = date.day.toString() +
            '/' +
            date.month.toString() +
            '/' +
            date.year.toString() +
            ' @ ';
      else
        appendedTime = date.day.toString() +
            '/0' +
            date.month.toString() +
            '/' +
            date.year.toString() +
            ' @ ';
    }
    if (hour > 12) {
      hour = hour - 12;
      if (DateTime.fromMillisecondsSinceEpoch(millisec).minute >= 10)
        appendedTime += hour.toString() +
            ':' +
            DateTime.fromMillisecondsSinceEpoch(millisec).minute.toString() +
            ' PM';
      else
        appendedTime += hour.toString() +
            ':0' +
            DateTime.fromMillisecondsSinceEpoch(millisec).minute.toString() +
            ' PM';
    } else {
      if (DateTime.fromMillisecondsSinceEpoch(millisec).minute >= 10)
        appendedTime += hour.toString() +
            ':' +
            DateTime.fromMillisecondsSinceEpoch(millisec).minute.toString() +
            ' AM';
      else
        appendedTime += hour.toString() +
            ':0' +
            DateTime.fromMillisecondsSinceEpoch(millisec).minute.toString() +
            ' AM';
    }
    return appendedTime;
  }

  Widget _buildTextField() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              getImageFile();
            },
            icon: Icon(Icons.image),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              style: TextStyle(
                color: Colors.black,
              ),
              autofocus: false,
              controller: _controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if (_controller.text != '') {
                db.sendMessageToGroup(widget.doc.documentID, _controller.text,
                    widget.user.uid, 0, widget.user.name);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              padding: EdgeInsets.only(right: 0),
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.doc['photourl']),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.doc['name']),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('Groups')
            .document(widget.doc.documentID)
            .collection(widget.doc.documentID)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          int prevCount = 0;
          return !snapshot.hasData
              ? SizedBox.shrink()
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            reverse: true,
                            itemCount: snapshot?.data?.documents?.length,
                            itemBuilder: (context, index) {
                              var doc = snapshot?.data?.documents[index];
                              int count = 0;
                              for (int i = index; i >= 0; i--) {
                                if (snapshot.data.documents[i]['fromUid'] ==
                                    doc['fromUid']) {
                                  if (count != 0) prevCount = count;
                                  count++;
                                }
                              }
                              print("prev" + prevCount.toString());
                              print("count" + count.toString());
                              if (doc['fromUid'] != widget.user.uid)
                                return Row(
                                  //To User
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (prevCount > count)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 5,
                                                left: 8,
                                                right: 0,
                                                bottom: 0),
                                            child: Text(
                                              doc['name'],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 200,
                                            ),
                                            child: doc['type'] == 0
                                                ? Text(
                                                    doc['content'],
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  )
                                                : ClipRRect(
                                                    child: CachedNetworkImage(
                                                      imageUrl: doc['content'],
                                                      placeholder:
                                                          (context, imageUrl) =>
                                                              Loading(),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                      topRight:
                                                          Radius.circular(8.0),
                                                      bottomRight:
                                                          Radius.circular(8.0),
                                                    ),
                                                  ),
                                            padding: doc['type'] == 0
                                                ? EdgeInsets.fromLTRB(
                                                    15.0, 10.0, 15.0, 10.0)
                                                : EdgeInsets.all(2),
                                            decoration: doc['type'] == 0
                                                ? BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                      topRight:
                                                          Radius.circular(8.0),
                                                      bottomRight:
                                                          Radius.circular(8.0),
                                                    ),
                                                    border: Border.all(
                                                        color: Colors.blue))
                                                : null,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, left: 8),
                                          child: Text(
                                            timeFormat(int.parse(doc['time'])),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              else
                                return Row(
                                  //Form User
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 200,
                                            ),
                                            child: doc['type'] == 0
                                                ? Text(
                                                    doc['content'],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : ClipRRect(
                                                    child: CachedNetworkImage(
                                                      imageUrl: doc['content'],
                                                      placeholder:
                                                          (context, imageUrl) =>
                                                              Loading(),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                      topRight:
                                                          Radius.circular(8.0),
                                                      bottomLeft:
                                                          Radius.circular(8.0),
                                                    ),
                                                  ),
                                            padding: doc['type'] == 0
                                                ? EdgeInsets.fromLTRB(
                                                    15.0, 10.0, 15.0, 10.0)
                                                : EdgeInsets.all(2),
                                            decoration: doc['type'] == 0
                                                ? BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                      topRight:
                                                          Radius.circular(8.0),
                                                      bottomLeft:
                                                          Radius.circular(8.0),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, right: 8),
                                          child: Text(
                                            timeFormat(int.parse(doc['time'])),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                            }),
                      ),
                    ),
                    _buildTextField(),
                  ],
                );
        },
      ),
    );
  }
}
