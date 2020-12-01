import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf_text/pdf_text.dart';

import 'package:path/path.dart' as path;
import 'package:condition/condition.dart';
import 'package:frino_icons/frino_icons.dart';

import 'package:open_file/open_file.dart';

//import 'package:flutter_multiselection_list/home_page.dart';

class GridItem extends StatefulWidget {
  final Key key;
  final File item;
  final ValueChanged<bool> isSelected;

  GridItem({this.item, this.isSelected, this.key});

  @override
  _GridItemState createState() => _GridItemState(item);
}

class _GridItemState extends State<GridItem> {
  File item;
  bool isSelected = false;
  _GridItemState(this.item);
  // File file;

  String result;
  PDFDoc doc;
  String docText;
  List selectfile = new List();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
              Widget>[
        Conditioned.boolean(
          path.basename(item.path).contains(RegExp(r'.pdf')),
          trueBuilder: () => IconButton(
            padding: const EdgeInsets.only(left: 8, bottom: 40, right: 20),
            icon: Icon(
              FrinoIcons.f_file_pdf,
              size: 45,
              color: Colors.cyan[700],
              //colorBlendMode: BlendMode.color,
            ),
            onPressed: () async {
              OpenFile.open(item.path);
            },
          ),
          falseBuilder: () => IconButton(
              padding: const EdgeInsets.only(left: 8, bottom: 40, right: 20),
              icon: Icon(
                FrinoIcons.f_file_txt,
                size: 45,
                color: Colors.cyan[700],
              ),
              onPressed: () async {
                OpenFile.open(item.path);
              }),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              path.basename(item.path),
              style: TextStyle(color: Colors.cyan[800], fontFamily: 'Sans'),
            )),
        isSelected
            ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Icon(
                    Icons.check_circle,
                    size: 30,
                    color: Colors.cyan[700],
                  ),
                ),
              )
            : Container(),
      ])),
    );
  }
}
