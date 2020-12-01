import 'package:flutter/material.dart';
import 'package:html_editor/html_editor.dart';

import 'package:ext_storage/ext_storage.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:scantext/main.dart';

import 'package:share_extend/share_extend.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import 'dart:math';

class ViewText extends StatefulWidget {
  final String text;
  ViewText(this.text);
  @override
  _ViewTextState createState() => _ViewTextState(text);
}

class _ViewTextState extends State<ViewText> {
  _ViewTextState(this.text);
  final String text;
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  String result = "";
  List file2 = new List();

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text(
        "PDF",
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
      color: Colors.cyan[800],
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.white, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(50)),
      onPressed: () async {
        final pdf = pw.Document();

        pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("$text"),
          ); // Center
        }));

        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        // Page

        var dir = await ExtStorage.getExternalStorageDirectory();
        int rand = new Random().nextInt(100000);
        DateTime ketF = new DateTime.now();
        String baru = "${ketF.year}${ketF.month}${ketF.day}";

        var testdir =
            await new Directory('$dir/ScanText/').create(recursive: true);

        File file = File("${testdir.path}/ScanDocument_$baru$rand.pdf");
        await file.writeAsBytes(pdf.save());

        //file.writeAsStringSync("test for share documents file");

        ShareExtend.share(file.path, "file");

        Navigator.pop(context);

        setState(() {
          file2.add(file);
        });
      },
    );

    Widget docs = FlatButton(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          'DOC',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        color: Colors.cyan[800],
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.white, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          final dir = await ExtStorage.getExternalStorageDirectory();
          var testdir =
              await new Directory('$dir/ScanText/').create(recursive: true);

          int rand = new Random().nextInt(100000);
          DateTime ketF = new DateTime.now();
          String baru = "${ketF.year}${ketF.month}${ketF.day}";

          File file = File("${testdir.path}/ScanDocument_$baru$rand.txt");

          // Write the file
          file.writeAsString('$text');

          ShareExtend.share(file.path, "file");
          Navigator.pop(context);
        });

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("SHARE FILE", style: TextStyle(color: Colors.white)),
      content: Text("Select the format to share the file",
          style: TextStyle(color: Colors.white)),
      actions: [
        okButton,
        docs,
      ],
      elevation: 24.0,
      backgroundColor: Colors.cyan[800],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog1(BuildContext context) {
    // Create button
    Widget okButton1 = FlatButton(
      child: Text(
        "PDF",
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
      color: Colors.cyan[800],
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.white, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(50)),
      onPressed: () async {
        final pdf = pw.Document();

        pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("$text"),
          ); // Center
        }));

        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        // Page

        var dir = await ExtStorage.getExternalStorageDirectory();
        int rand = new Random().nextInt(100000);
        DateTime ketF = new DateTime.now();
        String baru = "${ketF.year}${ketF.month}${ketF.day}";

        var testdir =
            await new Directory('$dir/ScanText').create(recursive: true);

        File file = File("${testdir.path}/ScanDocument_$baru$rand.pdf");
        await file.writeAsBytes(pdf.save());
        Navigator.pop(context);
        setState(() {
          file2.add(file);
        });

        // Navigator.push(
        //   context,
        //    MaterialPageRoute(builder: (context) => MyHomePage()),
        // );
        //file.writeAsStringSync("test for share documents file");
      },
    );

    Widget docs1 = FlatButton(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          'DOC',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        color: Colors.cyan[800],
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.white, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          final dir = await ExtStorage.getExternalStorageDirectory();
          var testdir =
              await new Directory('$dir/ScanText/').create(recursive: true);

          int rand = new Random().nextInt(100000);
          DateTime ketF = new DateTime.now();
          String baru = "${ketF.year}${ketF.month}${ketF.day}";

          File file = File("${testdir.path}/ScanDocument_$baru$rand.txt");

          // Write the file
          file.writeAsString('$text');
          Navigator.pop(context);
        });

    // Create AlertDialog
    AlertDialog alert1 = AlertDialog(
      title: Text("SAVE FILE", style: TextStyle(color: Colors.white)),
      content: Text("Select the format to save the file",
          style: TextStyle(color: Colors.white)),
      actions: [
        okButton1,
        docs1,
      ],
      backgroundColor: Colors.cyan[800],
      elevation: 24.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert1;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Text',
                style: TextStyle(fontSize: 25),
              ),
              elevation: 0,
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      showAlertDialog1(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(right: 25),
                    onPressed: () {
                      showAlertDialog(context);
                    }),
              ],
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HtmlEditor(
                      // hint: "Your text here...",
                      height: MediaQuery.of(context).size.height - 90,
                      value: "$text",
                      key: keyEditor,
                    ),
                    // FittedBox(
                    // fit: BoxFit.fitHeight,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(result),
                    )
                  ],
                ),
              ),
            ))
            // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
