import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  File _file = File(file!.path); // To get a file from an xfile!
  if (file != null) {
    // return File(_file.path); // Not accessible on flutter web now.
    return await file.readAsBytes(); // Returns Uint8List
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
