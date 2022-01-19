import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn/data/user_data.dart';
import 'package:sn/providers/email_sign_in.dart';
import 'package:sn/providers/email_sign_up.dart';
import 'package:sn/screens/create_profile_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
          'accedi',
          style: GoogleFonts.alata(),
        ),
      ),
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                child: const Text('registrati'),
                onPressed: () async {
                  // validate email
                  bool isEmailValid =
                      EmailValidator.validate(_emailController.text);

                  if (isEmailValid) {
                    // email is valid

                    // fetch username
                    List emailStrings = _emailController.text.split('@');
                    String username = emailStrings[0];

                    // sign-in user
                    UserCredential userCredential = await emailSignUp(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    );

                    // check if email is verified
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      // email is verified

                      // instatiate reference of Realtime Database
                      final DatabaseReference ref =
                          FirebaseDatabase.instance.ref();

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
                      // send verification email
                      await FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();

                      // show error dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('fatto!'),
                            content: const Text(
                              'account creato! ora devi verificare la tua email per continuare',
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
                  } else {
                    // email is not valid

                    // show error dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('errore!'),
                          content: const Text(
                            'l\'email che hai inserito non è valida',
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
              ),
              ElevatedButton(
                child: const Text('accedi'),
                onPressed: () async {
                  // validate email
                  bool isEmailValid =
                      EmailValidator.validate(_emailController.text);

                  if (isEmailValid) {
                    // email is valid

                    // fetch username
                    List emailStrings = _emailController.text.split('@');
                    String username = emailStrings[0];

                    // sign-in user
                    UserCredential userCredential = await emailSignIn(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    );

                    // check if email is verified
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      // email is verified

                      // instatiate reference of Realtime Database
                      final DatabaseReference ref =
                          FirebaseDatabase.instance.ref();

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
                      await FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();

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
                  } else {
                    // email is not valid

                    // show error dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('errore!'),
                          content: const Text(
                            'l\'email che hai inserito non è valida',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
