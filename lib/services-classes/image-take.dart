import 'dart:io';

import 'package:faveremit_admin/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

var myPicker = ImagePicker();

Future<File?> pickImage(ImageSource imageSource) async {
  final _selected =
      await myPicker.pickImage(source: imageSource, imageQuality: 100);
  late File? _imageFile;
  if (_selected != null) {
    _imageFile = File(_selected.path);
  } else {
    _imageFile = null;
  }
  return _imageFile;
}

// Future<File?> cropImage({File? imageFile}) async {
//   File? _croppedImage = await ImageCropper.cropImage(
//     sourcePath: imageFile!.path,
//     aspectRatioPresets: [
//       CropAspectRatioPreset.square,
//     ],
//     androidUiSettings: AndroidUiSettings(
//       activeControlsWidgetColor: kPrimaryColor,
//       toolbarTitle: 'Cropper',
//       toolbarColor: kPrimaryColor,
//       toolbarWidgetColor: Colors.white,
//       initAspectRatio: CropAspectRatioPreset.original,
//       lockAspectRatio: false,
//     ),
//     iosUiSettings: const IOSUiSettings(
//       minimumAspectRatio: 1.0,
//     ),
//   );
//
//   return _croppedImage;
// }

class VeridoImagePicker {
  var myPicker = ImagePicker();

  Future<File?> takePhoto(BuildContext context) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  'Camera',
                  style: GoogleFonts.poppins(color: kPrimaryColor),
                ),
                onPressed: () async {
                  File? _pickedImage = await pickImage(ImageSource.camera);
                  Navigator.pop(context, _pickedImage);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Library',
                  style: GoogleFonts.poppins(color: kPrimaryColor),
                ),
                onPressed: () async {
                  File? _pickedImage = await pickImage(ImageSource.gallery);

                  Navigator.pop(context, _pickedImage);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'cancel',
                style: TextStyle(color: kRed),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }
}
