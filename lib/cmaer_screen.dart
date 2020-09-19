import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:ext_storage/ext_storage.dart';

final picker = ImagePicker();

Future<String> takeimage() async {
  var pickedFile = await picker.getImage(source: ImageSource.camera);

  var dir = await ExtStorage.getExternalStorageDirectory();
  var testdir = await new Directory('$dir/b/MyImage').create(recursive: true);

  print(testdir.path);
  String tmpFile = pickedFile.path;

  //final pathss = ourTempFile.path;

  //final String fileName =
  // basename(pickedFile.path); // Filename without extension
  //final String fileExtension = extension(pickedFile.path); // e.g. '.jpg'

  //mpFile = '${testdir.path}/$fileName$fileExtension';

  return tmpFile;
}
