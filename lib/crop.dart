import 'package:flutter/material.dart';
import 'dart:io';
//import 'dart:ui';
import 'dart:async';

import 'package:scantext/image_detail.dart';
import 'package:image_crop/image_crop.dart';

// ignore: camel_case_types
class cropScreen extends StatefulWidget {
  final File imagePath;
  cropScreen(this.imagePath);

  @override
  _cropScreenState createState() => _cropScreenState(imagePath);
}

// ignore: camel_case_types
class _cropScreenState extends State<cropScreen> {
  final File imagePath;
  _cropScreenState(this.imagePath);

  final cropKey = GlobalKey<CropState>();

  // Size _imageSize;
  File imageFile;
  File tt;

  Future<void> _cropImage() async {
    // final Image imageFile = Image.file(path);
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    final sample = await ImageCrop.sampleImage(
      file: imagePath,
      preferredWidth: (1024 / scale).round(),
      preferredHeight: (4096 / scale).round(),
    );

    final file1 = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    /* var dir = await ExtStorage.getExternalStorageDirectory();
    var testdir = await new Directory('$dir/b/MyImage').create(recursive: true);
    print(testdir.path);
    final String fileName = basename(file1.path); // Filename without extension
    final String fileExtension = extension(file1.path); // e.g. '.jpg'

    final tmpFile = await file1.copy('${testdir.path}/$fileName$fileExtension'); */
    setState(() {
      imageFile = file1;
    });
    debugPrint('$file1');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Crop Image",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  decoration: TextDecoration.none),
            ),
          ),
          Expanded(
            child: Crop.file(imagePath, key: cropKey),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            alignment: AlignmentDirectional.center,
            child: SizedBox(
              width: 70.0,
              height: 70.0,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  _cropImage();
                  new Future.delayed(new Duration(seconds: 3), () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(imageFile),
                      ),
                    );
                  });
                },
                child: Icon(
                  Icons.check_circle,
                  size: 65,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ]));

    /*  width: double.maxFinite,
              color: Colors.black,
              child: Crop.file(
                imagePath,
                key: cropKey,
                aspectRatio: 4.0 / 3.0,
              )

    );

      background: Colors.white,
        appBar: AppBar(
          title: Text('Crop Image'),
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () async {
                  _cropImage();
                  new Future.delayed(new Duration(seconds: 3), () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(imageFile),
                      ),
                    );
                  });
                })
          ],
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          /* child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(*/
          child: Container(
              width: double.maxFinite,
              color: Colors.black,
              child: Crop.file(
                imagePath,
                key: cropKey,
                aspectRatio: 4.0 / 3.0,
              )),
        )

        //  ]
        //  ),
        //   ),*/
  }
}
