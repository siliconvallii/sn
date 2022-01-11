import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_up.dart';

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

void sendToRandom(imageUrl) async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // get randomUser
  Map randomUser = await getRandomUser();
  while (randomUser == user['uid']) {
    randomUser = await getRandomUser();
  }

  // put image in randomUser's inbox
  ref
      .child('users')
      .child(randomUser['uid'])
      .child('inbox')
      .child(user['uid'])
      .set({
    'image': imageUrl,
    'date': DateTime.now().toUtc().toString(),
    'sender': user['uid'],
  });
}
