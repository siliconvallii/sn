import 'package:firebase_database/firebase_database.dart';

Future<Map> fetchUserData(String userUid) async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  Map userData = {};

  // fetch recipient data
  await ref.child('users').child(userUid).get().then((dynamic snapshot) {
    userData = snapshot;
  });

  return userData;
}
