import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_in.dart';

var users;

Future<Map> getRandomUser() async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  Map randomUser = {};

  await ref.get().then((snapshot) {
    users = snapshot.child('users').value;

    List usersList = [];
    users.forEach((key, value) => usersList.add(value));

    randomUser = (usersList.toList()..shuffle()).first;
  });

  return randomUser;
}

void sendImage(String imageUrl, String recipient) async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  if (recipient == 'random') {
    // get randomUser
    Map randomUser = await getRandomUser();
    while (randomUser['uid'] == user['uid']) {
      randomUser = await getRandomUser();
    }

    // put image in randomUser's inbox
    ref.child('inboxes').child(randomUser['uid']).child(user['uid']).set(
      {
        'image': imageUrl,
        'date': DateTime.now().toUtc().toString(),
        'sender': user,
        'viewed': false,
      },
    );
  } else {
    // put image in recipient's inbox
    ref.child('inboxes').child(recipient).child(user['uid']).set(
      {
        'image': imageUrl,
        'date': DateTime.now().toUtc().toString(),
        'sender': user,
        'viewed': false,
      },
    );
  }
}
