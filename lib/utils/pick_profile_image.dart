import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickProfileImage() async {
  final XFile? image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );

  File? croppedImage = await ImageCropper.cropImage(
    sourcePath: image!.path,
    aspectRatioPresets: [CropAspectRatioPreset.square],
  );
  return croppedImage;
}
