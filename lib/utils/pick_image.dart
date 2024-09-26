// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List> pickImage(ImageSource source) async {
  final ImagePicker _imagepicker = ImagePicker();

  try {
    XFile? _file = await _imagepicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print("No image is selected");
  } catch (e) {
    print("$e");
  }
  return Uint8List(0);
}
