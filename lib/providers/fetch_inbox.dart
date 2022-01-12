import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_up.dart';

Future<List> fetchInbox() async {
  var inbox;
  List inboxList = [];

  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // create or update user in Realtime Database
  await ref.child('inboxes').child(user['uid']).get().then((value) {
    inbox = value.value;
  });

  await inbox.forEach((key, value) => inboxList.add(value));

  return inboxList;
}
