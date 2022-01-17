import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_in.dart';

Future<bool> fetchIfFriends(friendUid) async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  bool areFriends = false;

  await ref
      .child('users')
      .child(friendUid)
      .child('friends')
      .get()
      .then((value) {
    if (value.exists) {
      dynamic friendsList = value.value;

      if (friendsList.contains(user['uid'])) {
        areFriends = true;
      }
    }
  });

  return areFriends;
}
