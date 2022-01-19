import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sn/data/user_data.dart';
import 'package:sn/providers/email_sign_in.dart';
import 'package:sn/screens/create_profile_screen.dart';

Future silentEmailSignIn(context, email, password) async {
  // fetch username
  List emailStrings = email.split('@');
  String username = emailStrings[0];

  // sign-in user
  UserCredential userCredential = await emailSignIn(
    context,
    email,
    password,
  );

  // check if email is verified
  if (FirebaseAuth.instance.currentUser!.emailVerified) {
    // email is verified

    // instatiate reference of Realtime Database
    final DatabaseReference ref = FirebaseDatabase.instance.ref();

    await ref
        .child('users')
        .child(userCredential.user!.uid)
        .get()
        .then((value) {
      // check if user is new
      if (value.exists) {
        // user isn't new

        // store user Map locally
        user = value.value;

        // navigate to HomeScreen
        Navigator.pushNamed(context, '/home');
      } else {
        // user is new

        // navigate to CreateProfileScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfileScreen(
              username: username,
              uid: userCredential.user!.uid,
            ),
          ),
        );
      }
    });
  } else {
    // email isn't verified
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();

    // show error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('errore!'),
          content: const Text(
            'devi verificare la tua email per continuare',
          ),
          actions: <TextButton>[
            TextButton(
              child: const Text('ok'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
