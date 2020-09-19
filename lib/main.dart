import 'dart:io';

import 'package:condition/condition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:scantext/cmaer_screen.dart';
import 'package:scantext/import_image.dart';
import 'package:scantext/image_detail.dart';
import 'package:ext_storage/ext_storage.dart';

import 'package:pdf_text/pdf_text.dart';
import 'package:scantext/text_view.dart';
import 'package:path/path.dart' as path;
import 'package:frino_icons/frino_icons.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.cyan[800],
        accentColor: Colors.cyan,
      ),
      home: MyHomePage(
          // Pass the appropriate camera to the TakePictureScreen widget.

          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String directory;
  List file = new List();
  String result;
  PDFDoc doc;
  String docText;
  // RegExp exp = new RegExp(r"^[a-zA-Z0-9_.+-]+.[a-zA-Z0-9-]$");

  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  // Make New Function
  void _listofFiles() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final dir = await ExtStorage.getExternalStorageDirectory();
    var testdir = await new Directory('$dir/b/MyImage').create(recursive: true);

    setState(() {
      file = testdir.listSync(); //use your folder name insted of resume.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan Text'),
        ),
        body: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                scrollDirection: Axis.horizontal,
                children: List.generate(file.length, (index) {
                  Text(path.basename(file[index].path));
                  TextStyle(color: Colors.black);
                  return Container(
                      //Text(file.toString()),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Conditioned.boolean(
                          path
                              .basename(file[index].path)
                              .contains(RegExp(r'.pdf')),
                          trueBuilder: () => IconButton(
                            icon: Icon(
                              FrinoIcons.f_file_pdf,
                              size: 40,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              doc = await PDFDoc.fromFile(file[index]);
                              docText = await doc.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewText(
                                    docText,
                                  ),
                                ),
                              );
                            },
                          ),
                          falseBuilder: () => IconButton(
                              icon: Icon(
                                FrinoIcons.f_file_txt,
                                size: 40,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                docText =
                                    await rootBundle.loadString(file[index]);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewText(
                                      docText,
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Text(path.basename(file[index].path))
                      ]));

                  // itemCount: file.length,
                  //itemBuilder: (BuildContext context, int index) {
                }),
              )),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () async {
                  await takeimage().then((String path) {
                    if (path != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(path),
                        ),
                      );
                    }
                  });
                },
                heroTag: "btn1",
                child: Icon(Icons.camera),
              ),
              FloatingActionButton(
                onPressed: () async {
                  await getImage().then((String path) {
                    if (path != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(path),
                        ),
                      );
                    }
                  });
                },
                heroTag: "btn2",
                child: Icon(Icons.add_photo_alternate),
              )
            ],
          ),
        ));
  }
}
