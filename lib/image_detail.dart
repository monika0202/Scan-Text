import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:scantext/text_view.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
//import 'package:rounded_loading_button/rounded_loading_button.dart';

class DetailScreen extends StatefulWidget {
  final File imagePath;
  DetailScreen(this.imagePath);

  @override
  _DetailScreenState createState() => new _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.imagePath);

  final File imagePath;

  final TextRecognizer textRecognizer =
      FirebaseVision.instance.textRecognizer();

  // final RoundedLoadingButtonController _btnController =
  // new RoundedLoadingButtonController();

  Size _imageSize;
  String recognizedText;
  var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

  void _initializeVision() async {
    final File imageFile = imagePath;

    // if (imageFile != null) {
    await _getImageSize(imageFile);
    //  }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    String text = "";

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            text = text + word.text + ' ';
          });
        }
        text = text + '\n';
      }
    }

    if (this.mounted) {
      setState(() {
        recognizedText = text;
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(imageFile);

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
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10, right: 50, top: 15, left: 30),
                child: new CircularProgressIndicator(
                  backgroundColor: null,
                ),
              ),
              Text("Loading...")
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewText(
            recognizedText,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scan Image",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: _imageSize != null
          ? Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: double.maxFinite,
                    color: Colors.black,
                    child: AspectRatio(
                      aspectRatio: _imageSize.aspectRatio,
                      child: Image.file(
                        imagePath,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 20.0, left: 40.0),
                        // child: RoundedLoadingButton(
                        child: NiceButton(
                          radius: 40,
                          padding: const EdgeInsets.all(15),
                          text: "SCAN",
                          gradientColors: [secondColor, firstColor],
                          onPressed: () {
                            _onLoading();
                            // Navigator.pop(context);
                          },
                          background: null,
                        ),
                        // controller: _btnController,
                        // ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
