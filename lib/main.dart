import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sn/screens/home_screen.dart';
import 'package:sn/screens/initial_screen.dart';
import 'package:sn/screens/new_chat_screen.dart';
import 'package:sn/screens/sign_up_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const SN());
}

class SN extends StatelessWidget {
  const SN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/initial',
      routes: {
        '/home': (BuildContext context) => const HomeScreen(),
        '/initial': (BuildContext context) => const InitialScreen(),
        '/new_chat': (BuildContext context) => NewChatScreen(),
        '/sign_up': (BuildContext context) => const SignUpScreen(),
      },
    );
  }
}
