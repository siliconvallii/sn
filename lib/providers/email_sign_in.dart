import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future emailSignIn(BuildContext context, String email, String password) async {
  // dismiss keyboard
  FocusManager.instance.primaryFocus?.unfocus();

  // show loading indicator
  showDialog(
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xffBC91F8),
        ),
      );
    },
    context: context,
  );

  // fetch email domain
  List<String> emailStrings = email.split('@');
  String emailDomain = emailStrings[1];

  // check if email is allowed
  if (emailDomain != '') {
    // email is allowed

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // pop loading indicator
      Navigator.pop(context);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // user not found

        // pop loading indicator
        Navigator.pop(context);

        // show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('errore!'),
              content: const Text(
                'non esiste un account con questa email',
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
      } else if (e.code == 'wrong-password') {
        // password is wrong

        // pop loading indicator
        Navigator.pop(context);

        // show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('errore!'),
              content: const Text(
                'la password che hai inserito è sbagliata',
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
      // unknown error

      // pop loading indicator
      Navigator.pop(context);

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

    // pop loading indicator
    Navigator.pop(context);

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
