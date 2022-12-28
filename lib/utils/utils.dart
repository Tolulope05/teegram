import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File> _cropFile(File imageFile) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    maxHeight: 406,
  );
  if (croppedFile == null) {
    return imageFile;
  }
  //  kIsWeb ? Image.network(path) : Image.file(File(path))

  return File(croppedFile.path);
}

pickImage(ImageSource source) async {
  // File _file = File(file!.path); // To get a file from an xfile!

  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);

  File croppedFile = await _cropFile(File(file!.path));
  if (croppedFile != null) {
    // return File(croppedFile.path); // Not accessible on flutter web now.
    Uint8List fileInByte = await croppedFile.readAsBytes(); // Returns Uint8List
    return fileInByte;
  }
  return;
}

// croppedImage(ImageSource source) async {
//   File _file
// }

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
