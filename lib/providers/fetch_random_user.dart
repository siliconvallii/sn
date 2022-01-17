import 'package:firebase_database/firebase_database.dart';
import 'package:sn/providers/sign_in.dart';

Future<Map> fetchRandomUser() async {
  // instatiate reference of Realtime Database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  dynamic users;
  List randomUsersList = [];

  await ref.child('users').get().then((snapshot) {
    users = snapshot.value;

    users.forEach((key, value) {
      if (value['uid'] != null &&
          value['uid'] != user['uid'] &&
          user['friends'][value['uid']] == null) {
        randomUsersList.add(value);
      }
    });

    randomUsersList.shuffle();

    // put example user last in List
    randomUsersList.sort((a, b) {
      if (b['uid'] != 'example') {
        return 1;
      } else {
        return -1;
      }
    });
  });

  return randomUsersList[0];
}
