import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:scantext/image_detail.dart';

class CropScreen extends StatefulWidget {
  final File imagePath;
  CropScreen(this.imagePath);
  @override
  _CropScreenState createState() => _CropScreenState(imagePath);
}

class _CropScreenState extends State<CropScreen> {
  final File path;
  _CropScreenState(this.path);

  Size _imageSize;
  File imageFile;
  String tt;

  Future _getImageSize(imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(path);

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
    _cropImage(imageFile);
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath.path,
        maxWidth: 1080,
        maxHeight: 1080,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    String tmpFile = croppedImage.path;

    setState(() {
      tt = tmpFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () async {
                var dir = await ExtStorage.getExternalStorageDirectory();
                var testdir = await new Directory('$dir/b/MyImage')
                    .create(recursive: true);
                print(testdir.path);
              })
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  width: double.maxFinite,
                  color: Colors.black,
                  child: Image.file(
                    path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
