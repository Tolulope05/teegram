import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    // return File(_file.path); // Not accessible on flutter web now.
    return await _file.readAsBytes(); // Returns Uint8List
  }
  print('No Image selected.');
  return;
}
