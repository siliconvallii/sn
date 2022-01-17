import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_in.dart';

Future<Map> fetchRandomUser() async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  dynamic users;
  Map randomUser = {};

  await ref.child('users').get().then((snapshot) {
    users = snapshot.value;

    List usersList = [];
    users.forEach((key, value) => usersList.add(value));

    while (randomUser['uid'] == null ||
        randomUser['uid'] == user['uid'] ||
        randomUser['total_friends'] != 0 &&
            randomUser['friends'].contains(user['uid'])) {
      randomUser = (usersList.toList()..shuffle()).first;
    }

    // put example user last in List
    usersList.sort((a, b) {
      if (b['uid'] != 'example') {
        return 1;
      } else {
        return -1;
      }
    });
  });

  return randomUser;
}
