import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future emailSignUp(BuildContext context, String email, String password) async {
  // fetch email domain
  List<String> emailStrings = email.split('@');
  String emailDomain = emailStrings[1];

  // check if email is allowed
  if (emailDomain != '') {
    // email is allowed

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // password is weak

        // show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('errore!'),
              content: const Text(
                'la password che hai inserito è troppo debole',
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
      } else if (e.code == 'email-already-in-use') {
        // account already exists

        // show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('errore!'),
              content: const Text(
                'l\'email che hai inserito è già stata utilizzata',
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
    } catch (e) {
      // show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('errore!'),
            content: Text(e.toString()),
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
  } else {
    // email isn't allowed

    // show error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('errore!'),
          content: const Text(
            'l\'account che hai utilizzato per accedere non è autorizzato.\n'
            'assicurati di utilizzare un\'account collegato alla tua email '
            'istituzionale che termina con "@studenti.liceosarpi.bg.it". '
            'se non ne hai una, per ora non puoi accedere a eeloo.\nscusa!',
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
