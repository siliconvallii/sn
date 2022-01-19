import 'package:firebase_database/firebase_database.dart';
import 'package:sn/data/user_data.dart';

void sendImage(String imageUrl, String recipient) async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // put image in recipient's inbox
  await ref.child('inboxes').child(recipient).child(user['uid']).set(
    {
      'image': imageUrl,
      'date': DateTime.now().toUtc().toString(),
      'sender': user,
      'viewed': false,
    },
  );
}
