import 'package:flutter/material.dart';
import 'package:sn/screens/initial_screen.dart';

void main() {
  runApp(const SN());
}

class SN extends StatelessWidget {
  const SN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/initial',
      routes: {
        '/initial': (BuildContext context) => const InitialScreen(),
      },
    );
  }
}
