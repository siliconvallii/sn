import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  // pick image
  final XFile? image = await ImagePicker().pickImage(
    source: ImageSource.camera,
  );
  return image;
}
