import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sn/providers/sign_in.dart';
import 'package:uuid/uuid.dart';

void createProfile(
    context, profilePicture, classValue, sectionValue, bioString) async {
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
  user['profile_picture'] = profilePictureUrl;
  user['class'] = classValue;
  user['section'] = sectionValue;
  user['bio'] = bioString;

  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // create or update user in Realtime Database
  await ref.child('users').child(user['uid']).set(user);

  // navigate to HomeScreen
  Navigator.pushNamed(context, '/home');
}
