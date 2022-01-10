import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Map user = {};

void signUp(BuildContext context) async {
  // fetch Google user
  GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

  // fetch email domain
  List<String> emailStrings = googleSignInAccount!.email.split('@');
  String emailDomain = emailStrings[1];

  // check if email domain is allowed
  if (emailDomain == 'studenti.liceosarpi.bg.it') {
    // email domain is allowed

    // fetch credential from Google User
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    // authenticate with credential in Firebase Auth
    UserCredential auth =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // instatiate reference of Realtime Database
    final DatabaseReference ref = FirebaseDatabase.instance.ref();

    // create user map
    user = {
      'username': emailStrings[0],
      'profile_pic': auth.user!.photoURL,
      'uid': auth.user!.uid,
    };

    // create or update user in Realtime Database
    await ref.child('users').child(auth.user!.uid).set(user);

    // navigate to HomeScreen
    Navigator.pushNamed(context, '/home_screen');
  } else {
    // email domain is not allowed
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Errore!'),
          content: const Text(
            'L\'account che hai utilizzato per accedere non è autorizzato.\n'
            'Assicurati di utilizzare un\'account collegato alla tua email '
            'istituzionale che termina con "@studenti.liceosarpi.bg.it". '
            'Se non ne hai una, per ora non puoi accedere a SN.\nScusa!',
          ),
          actions: <TextButton>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
