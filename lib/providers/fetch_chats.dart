import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_in.dart';

Future<List> fetchChats() async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // fetch chats
  List chats = [];

  await ref.child('chats').get().then((snapshot) async {
    List friends = [];

    // fetch all chats
    dynamic _allChatsMap = snapshot.value;

    await _allChatsMap.forEach((key, value) {
      // check if user is involved in each chat
      if (key.contains(user['uid'])) {
        // user is involved

        // fetch other user uid
        String otherUserUid = '';

        if (value['sender'] == user['uid']) {
          otherUserUid = value['recipient'];

          // add has_to_reply
          value['has_to_reply'] = false;
        } else {
          otherUserUid = value['sender'];

          // add has_to_reply
          value['has_to_reply'] = true;
        }

        // update friendship status
        int hoursSinceLast =
            DateTime.now().difference(DateTime.parse(value['sent_at'])).inHours;

        // check if users are in touch
        if (hoursSinceLast < 24) {
          // users are friends

          // update friendship status to true
          ref.child('chats').child(key).child('friends').set(true);

          // add friend to friends List
          friends.add(otherUserUid);
        } else {
          // users aren't friends

          // update friendship status to false
          ref.child('chats').child(key).child('friends').set(false);
        }

        // add chat to chatsMap
        chats.add(value);
      }
    });
    // update friends List
    await ref
        .child('users')
        .child(user['uid'])
        .child('friends')
        .set(friends)
        .then((snap) => user['friends'] = friends);

    // update totalFriends
    await ref
        .child('users')
        .child(user['uid'])
        .child('total_friends')
        .set(friends.length)
        .then((snap) => user['total_friends'] = friends.length);
  });

  // sort chats List
  chats.sort((a, b) {
    if (b['has_to_reply']) {
      return 1;
    } else {
      return -1;
    }
  });

  return chats;
}
