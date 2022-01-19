import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sn/data/user_data.dart';
import 'package:uuid/uuid.dart';

void createProfile(context, username, uid, profilePicture, classValue,
    sectionValue, bioString) async {
  // dismiss keyboard
  FocusManager.instance.primaryFocus?.unfocus();

  // show loading indicator
  showDialog(
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xffBC91F8),
        ),
      );
    },
    context: context,
  );

  // generate random image id
  String imageId = const Uuid().v4();

  // instatiate reference with Firebase Storage
  Reference reference = FirebaseStorage.instance.ref().child(imageId);

  // uploade image to Firebase Storage
  await reference.putFile(profilePicture);

  // fetch image download URL
  String profilePictureUrl = '';
  await reference
      .getDownloadURL()
      .then((_imageURL) => profilePictureUrl = _imageURL);

  // update locally stored user map
  user['username'] = username;
  user['uid'] = uid;
  user['profile_picture'] = profilePictureUrl;
  user['class'] = classValue;
  user['section'] = sectionValue;
  user['bio'] = bioString;
  user['total_friends'] = 0;

  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // create or update user in Realtime Database
  await ref.child('users').child(user['uid']).set(user);

  // pop loading indicator
  Navigator.pop(context);

  // navigate to HomeScreen
  Navigator.pushNamed(context, '/home');
}
