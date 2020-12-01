import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:scantext/cmaer_screen.dart';
import 'package:scantext/import_image.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:share_extend/share_extend.dart';

import 'package:pdf_text/pdf_text.dart';
import 'package:scantext/text_view.dart';
import 'package:path/path.dart' as path;

import 'package:scantext/crop.dart';
import 'package:scantext/grid.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Make New Function

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.cyan[700],
          accentColor: Colors.cyan,
        ),
        home: MyHomePage(
            // Pass the appropriate camera to the TakePictureScreen widget
            ),
        debugShowCheckedModeBanner: false);
  }
}

class MyHomePage extends StatefulWidget {
  final List file = new List();
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState(file);
}

class _MyHomePageState extends State<MyHomePage> {
  String directory;
  List file = new List();
  String result;
  PDFDoc doc;
  String docText;
  List selectfile = new List();

  bool isSelected = false;

  _MyHomePageState(List file);

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
    var testdir = await new Directory('$dir/ScanText/').create(recursive: true);

    setState(() {
      file = testdir.listSync(); //use your folder name insted of resume.
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
              style: TextStyle(color: Colors.cyan[800]),
            ),
            content: new Text('Do you want to exit Scan Text',
                style: TextStyle(color: Colors.cyan[800])),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "NO",
                  style: TextStyle(fontSize: 22),
                ),
                hoverColor: Colors.cyan[700],
                focusColor: Colors.cyan[700],
                splashColor: Colors.cyan[700],
                textTheme: ButtonTextTheme.accent,
                // highlightColor: Colors.cyan[700],
              ),
              // SizedBox(height: 20),
              new FlatButton(
                padding: const EdgeInsets.only(left: 15, right: 20),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  "YES",
                  style: TextStyle(fontSize: 22),
                ),
                hoverColor: Colors.cyan[700],
                focusColor: Colors.cyan[700],
                splashColor: Colors.cyan[700],
                textTheme: ButtonTextTheme.accent,
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: getAppBar(),

            /*AppBar(
          title: Text('Scan Text'),
        ),  */
            body: Center(
                child: Flexible(
                    child: Column(children: <Widget>[
              Expanded(
                child: GridView.builder(
                    primary: false,
                    padding: const EdgeInsets.only(left: 15, right: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 4,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: file.length,
                    //List.generate(file.length, (index)),

                    itemBuilder: (context, index) {
                      return GridItem(
                          item: file[index],
                          isSelected: (bool value) {
                            setState(() {
                              if (value) {
                                selectfile.add(file[index]);
                              } else {
                                selectfile.remove(file[index]);
                              }
                            });

                            print("$index : $value");
                          },
                          key: Key(file[index].toString()));
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, bottom: 15, left: 15, right: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 70.0,
                          height: 70.0,
                          child: FloatingActionButton(
                            backgroundColor: Colors.cyan[700],
                            onPressed: () async {
                              File path = await takeimage();
                              if (path != null) {
                                // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => cropScreen(path),
                                  ),
                                );
                              }
                            },
                            heroTag: "btn1",
                            child: Icon(
                              Icons.camera,
                              size: 54,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 70.0,
                            height: 70.0,
                            child: FloatingActionButton(
                              backgroundColor: Colors.cyan[700],
                              onPressed: () async {
                                await getImage().then((File path) {
                                  if (path != null) {
                                    //  Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => cropScreen(path),
                                      ),
                                    );
                                  }
                                });
                              },
                              heroTag: "btn2",
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.white,
                              ),
                            ))
                      ]))
            ])))));
  }

  Widget getAppBar() {
    return AppBar(
        title: Flexible(
            fit: FlexFit.loose,
            child: Row(children: <Widget>[
              Image.asset(
                'assets/jj.png',
                fit: BoxFit.fitHeight,
                height: 50,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                      selectfile.length < 1
                          ? "Scan Text"
                          : "${selectfile.length} selected",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w500,
                      )))
            ])),
        textTheme:
            TextTheme(bodyText1: TextStyle(fontFamily: 'Ubuntu', fontSize: 30)),
        actions: <Widget>[
          selectfile.length < 1
              ? Container()
              : InkWell(
                  onDoubleTap: () {
                    setState(() {
                      for (int i = 0; i < selectfile.length; i++) {
                        file.remove(selectfile[i]);
                      }
                      selectfile = List();
                    });
                  },
                  child: Flexible(
                      fit: FlexFit.tight,
                      // width: 30,
                      //  height: 20,
                      // constraints: BoxConstraints(maxHeight: 20, maxWidth: 40),
                      // alignment: Alignment.topRight,
                      // padding: const EdgeInsets.all(10.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                          // verticalDirection: VerticalDirection.up,
                          children: <Widget>[
                            selectfile.length != 1
                                ? Container()
                                : IconButton(
                                    icon: Icon(Icons.edit),
                                    padding: EdgeInsets.only(right: 10),
                                    onPressed: () async {
                                      for (int i = 0;
                                          i < selectfile.length;
                                          i++) {
                                        if (path
                                            .basename(selectfile[i].path)
                                            .contains(RegExp(r'.pdf'))) {
                                          //  String docText1 =
                                          await ReadPdfText.getPDFtext(
                                              selectfile[i].path);
                                          doc = await PDFDoc.fromFile(
                                              selectfile[i]);
                                          String docText1 = await doc.text;
                                          //trueBuilder: () =>

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ViewText(
                                                docText1,
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }

                                        // falseBuilder: () =>
                                        //
                                        else {
                                          docText = await selectfile[i]
                                              .readAsString();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ViewText(
                                                docText,
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      }
                                    }),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                for (int i = 0; i < selectfile.length; i++) {
                                  ShareExtend.share(selectfile[i].path, "file");
                                  Navigator.pop(context);
                                }
                              },
                              padding: EdgeInsets.only(right: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                for (int i = 0; i < selectfile.length; i++) {
                                  print(selectfile[i].path);
                                  File file1 = selectfile[i];
                                  setState(() {
                                    file.remove(selectfile[i]);
                                  });
                                  file1.delete();
                                }
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.only(right: 30),
                              icon: Icon(Icons.delete),
                            ),
                          ])),
                )
        ]);
  }
}
