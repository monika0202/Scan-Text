import 'package:flutter/material.dart';
import 'package:html_editor/html_editor.dart';

import 'package:ext_storage/ext_storage.dart';

import 'package:permission_handler/permission_handler.dart';

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

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text(
        "PDF",
        style: TextStyle(fontSize: 22),
      ),
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
            await new Directory('$dir/b/MyImage').create(recursive: true);

        File file = File("${testdir.path}/example2_$baru$rand.pdf");
        await file.writeAsBytes(pdf.save());

        //file.writeAsStringSync("test for share documents file");

        ShareExtend.share(file.path, "file");
      },
    );

    Widget docs = FlatButton(
        child: Text(
          'DOC',
          style: TextStyle(fontSize: 22),
        ),
        onPressed: () async {
          final dir = await ExtStorage.getExternalStorageDirectory();
          var testdir =
              await new Directory('$dir/b/MyImage').create(recursive: true);
          File file = File("${testdir.path}/example1_${DateTime.now()}.txt");

          // Write the file
          file.writeAsString('$text');

          ShareExtend.share(file.path, "file");
        });

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("SHARE FILE"),
      content: Text("Select the format to share the file"),
      actions: [
        okButton,
        docs,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                showAlertDialog(context);
              })
        ],
      ),

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HtmlEditor(
              // hint: "Your text here...",
              value: "$text",
              key: keyEditor,
              height: 556,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(result),
            )
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
