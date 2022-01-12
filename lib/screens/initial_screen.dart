import 'package:flutter/material.dart';
import 'package:sn/providers/sign_in.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
      ),
    );
  }
}
