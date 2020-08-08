import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'dart:io';
import 'notifications.dart';
import 'settings.dart';
import '../components/bottom_navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int _selectedIndex=2;

  File _image;

  getImageFile(ImageSource source) async {

    //Clicking or Picking from Gallery

    final _picker = ImagePicker();

    PickedFile image = await _picker.getImage(source: source);
    final File file = File(image.path);

    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
//      aspectRatioPresets: [CropAspectRatioPreset.square],
      maxWidth: 512,
      maxHeight: 512,
    );

    //Compress the image

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      croppedFile.path,
      quality: 50,
    );

    setState(() {
      _image = result;
      print(_image.lengthSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 2 ? Scaffold(
      bottomNavigationBar: BottomNavBar(
          selectedIndex: 2, onItemTapped: (index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text("Create a post", style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
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
              borderSide: new BorderSide(
              ),
            ),
            //fillColor: Colors.green
          ),
          validator: (val) {
            if(val.length==0) {
              return "Empty";
            }else{
              return null;
            }
          },
          ),
      ),
            Center(
              child: _image == null
                  ? Text("Image")
                  : Image.file(
                _image,
                height: 200,
                width: 200,
              ),
            ),
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
          )
        ],
      ),
    )
        : _selectedIndex == 0? HomePage() : _selectedIndex == 1? SearchPage() : _selectedIndex == 3? NotificationsPage() : SettingsPage();
  }
}
