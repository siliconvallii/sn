import 'package:flutter/material.dart';
import 'package:sn/providers/sign_up.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Ciao!'),
              ElevatedButton(
                onPressed: () {
                  signUp(context);
                },
                child: const Text('Entra con Google'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Accedi con Apple'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
