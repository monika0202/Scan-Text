import 'dart:async';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:ext_storage/ext_storage.dart';

final picker = ImagePicker();

Future<File> takeimage() async {
  final pickedFile = await picker.getImage(source: ImageSource.camera);

  var dir = await ExtStorage.getExternalStorageDirectory();
  var testdir = await new Directory('$dir/ScanText/').create(recursive: true);

  print(testdir.path);
  File tmpFile = File(pickedFile.path);

  return tmpFile;
}
