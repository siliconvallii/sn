import 'package:image_picker/image_picker.dart';

Future<XFile?> takeImage() async {
  // pick image
  final XFile? image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );

  return image;
}
