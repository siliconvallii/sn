import 'package:flutter/material.dart';

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
                  Navigator.pushNamed(context, '/sign_up');
                },
                child: const Text('Registrati'),
              ),
              const Text('oppure'),
              TextButton(
                onPressed: () {},
                child: const Text('Accedi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
