import 'package:flutter/material.dart';

class StartChatButton extends StatelessWidget {
  const StartChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Avvia una nuova chat'),
      onPressed: () {
        Navigator.pushNamed(context, '/new_chat');
      },
    );
  }
}
