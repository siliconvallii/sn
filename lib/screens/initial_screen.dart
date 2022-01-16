import 'package:flutter/material.dart';
import 'package:sn/providers/sign_in.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Image.asset('assets/images/initial_screen_image.png'),
            ),
            ElevatedButton(
              onPressed: () {
                signIn(context);
              },
              child: const Text('Entra con Google'),
            ),
            const Text('oppure'),
            TextButton(
              onPressed: () {},
              child: const Text('Accedi con Apple'),
            ),
          ],
        ),
      ),
    );
  }
}
