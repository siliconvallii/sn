import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_in.dart';

Future<List> fetchChats() async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // fetch chats
  List chats = [];

  await ref.child('chats').get().then((snapshot) async {
    // fetch all chats
    dynamic _allChatsMap = snapshot.value;

    await _allChatsMap.forEach((key, value) {
      // check if user is involved in each chat
      if (key.contains(user['uid'])) {
        // user is involved

        // update friendship status

        int hoursSinceLast =
            DateTime.now().difference(DateTime.parse(value['sent_at'])).inHours;

        // check if users are in touch
        if (hoursSinceLast < 24) {
          // users are friends

          // update friendship status to true
          ref.child('chats').child(key).child('friends').set(true);
        } else {
          // users aren't friends

          // update friendship status to false
          ref.child('chats').child(key).child('friends').set(false);
        }

        // add chat to chatsMap
        chats.add(value);
      }
    });
  });
  return chats;
}
