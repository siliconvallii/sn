import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn/data/user_data.dart';
import 'package:sn/providers/email_sign_in.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _marginSize = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2E2E2E),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'elimina account',
          style: GoogleFonts.alata(),
        ),
      ),
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Text(
                  'siamo dispiaciuti che tu voglia eliminare il tuo '
                  'account. se hai voglia, contattaci per dirci perché '
                  'te ne stai andando: ci farebbe molto piacere sapere '
                  'la tua opinione su eeloo.\n\n'
                  'ricorda che questa è un\'azione irreversibile, quando '
                  'avrai cancellato il tuo account nessuna informazione'
                  'sarà conservata.\n\n'
                  'per continuare inserisci l\'email e la password '
                  'collegate al tuo account.',
                  style: GoogleFonts.alata(
                    color: Colors.grey,
                  ),
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff1E1E1E),
                ),
                margin: EdgeInsets.only(
                  left: _marginSize,
                  right: _marginSize,
                  top: _marginSize,
                ),
                padding: const EdgeInsets.all(10),
              ),
              Container(
                child: TextField(
                  controller: _emailController,
                  cursorColor: const Color(0xffBC91F8),
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'email',
                    hintStyle: GoogleFonts.alata(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  style: GoogleFonts.alata(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff1E1E1E),
                ),
                margin: EdgeInsets.only(
                  left: _marginSize,
                  right: _marginSize,
                  top: _marginSize,
                ),
                padding: const EdgeInsets.all(10),
              ),
              Container(
                child: TextField(
                  controller: _passwordController,
                  cursorColor: const Color(0xffBC91F8),
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'password',
                    hintStyle: GoogleFonts.alata(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  obscureText: true,
                  style: GoogleFonts.alata(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff1E1E1E),
                ),
                margin: EdgeInsets.only(
                  left: _marginSize,
                  right: _marginSize,
                  top: _marginSize,
                ),
                padding: const EdgeInsets.all(10),
              ),
              ElevatedButton(
                child: const Text('elimina account'),
                onPressed: () async {
                  // dismiss keyboard
                  FocusManager.instance.primaryFocus?.unfocus();

                  // show loading indicator
                  showDialog(
                    barrierDismissible: false,
                    builder: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    context: context,
                  );

                  // sign-in user
                  try {
                    UserCredential userCredential = await emailSignIn(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    );

                    // instatiate reference of Realtime Database
                    final DatabaseReference ref =
                        FirebaseDatabase.instance.ref();

                    // delete chats
                    await ref.child('chats').get().then((snapshot) async {
                      // fetch all chats
                      dynamic _allChatsMap = snapshot.value;

                      await _allChatsMap.forEach((key, value) {
                        // check if user is involved in each chat
                        if (key.contains(user['uid'])) {
                          // user is involved

                          // delete chat
                          ref.child('chats').child(key).remove();
                        }
                      });
                    });

                    // delete user from Firebase Database
                    await ref.child('users').child(user['uid']).remove();

                    // delete user from Firebase Auth
                    await FirebaseAuth.instance.currentUser!.delete();

                    // pop loading indicator
                    Navigator.pop(context);

                    // show success dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('successo'),
                          content: const Text(
                            'hai eliminato con successo il tuo account',
                          ),
                          actions: <TextButton>[
                            TextButton(
                              child: const Text('ok'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/initial');
                              },
                            ),
                          ],
                        );
                      },
                    );
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
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xff63D7C6),
                  ),
                  foregroundColor:
                      MaterialStateProperty.all(const Color(0xff121212)),
                  textStyle: MaterialStateProperty.all(
                    GoogleFonts.alata(
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
