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

    // check if user is new
    if (auth.additionalUserInfo!.isNewUser) {
      // user is new

      // create user map
      user = {
        'username': emailStrings[0],
        'uid': auth.user!.uid,
      };

      // navigate to SignUpScreen
      Navigator.pushNamed(context, '/sign_up');
    } else {
      // user isn't new

      // instatiate reference of Realtime Database
      final DatabaseReference ref = FirebaseDatabase.instance.ref();

      // fetch user map
      ref.child('users').child(auth.user!.uid).get().then((snapshot) {
        user['uid'] = snapshot.child('uid').value;
        user['bio'] = snapshot.child('bio').value;
        user['profile_picture'] = snapshot.child('profile_picture').value;
        user['class'] = snapshot.child('class').value;
        user['section'] = snapshot.child('section').value;
        user['username'] = snapshot.child('username').value;
        print(user);
      });

      // navigate to HomeScreen
      Navigator.pushNamed(context, '/home');
    }
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
