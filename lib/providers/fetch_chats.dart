import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_in.dart';

Future<List> fetchChats() async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // fetch chats
  List chats = [];

  await ref.child('chats').get().then((snapshot) {
    // fetch all chats
    dynamic _allChatsMap = snapshot.value;

    _allChatsMap.forEach((key, value) {
      // check if user is involved in each chat
      if (key.contains(user['uid'])) {
        // user is involved, add chat to chatsMap
        chats.add(value);
      }
    });
  });

  return chats;
}
