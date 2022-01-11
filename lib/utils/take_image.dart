import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

Future<String> takeImage() async {
  // pick image
  final XFile? image = await ImagePicker().pickImage(
    source: ImageSource.camera,
  );

  // generate random image id
  String imageId = const Uuid().v4();

  // instatiate reference with Firebase Storage
  Reference reference = FirebaseStorage.instance.ref().child(imageId);

  // uploade image to Firebase Storage
  await reference.putFile(File(image!.path));

  // fetch image download URL
  String imageUrl = '';
  await reference.getDownloadURL().then((_imageURL) => imageUrl = _imageURL);

  return imageUrl;
}
