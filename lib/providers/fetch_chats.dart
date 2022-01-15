import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_in.dart';

Future<List> fetchChats() async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // fetch chats
  dynamic chatsMap;

  await ref.child('chats').get().then((snapshot) {
    // fetch all chats
    dynamic _allChatsMap = snapshot.value;

    _allChatsMap.forEach((String key, Map value) {
      // check if user is involved in each chat
      if (key.contains(user['uid'])) {
        // user is involved, add chat to chatsMap
        chatsMap.add(value);
      }
    });
  });

  // convert Map chatsMap in List chatsList
  List chatsList = [];
  chatsMap.forEach((String key, Map value) => chatsList.add(value));

  return chatsList;
}
