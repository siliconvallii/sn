import 'package:flutter/material.dart';
import 'package:sn/providers/sign_up.dart';

class OwnProfilePage extends StatelessWidget {
  const OwnProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                user['profile_picture'],
                scale: 5,
              ),
              Column(
                children: [
                  const Text('x amici'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Modifica profilo'),
                  ),
                ],
              ),
            ],
          ),
          Text(user['username']),
          Text('Liceo Sarpi - ' + user['class'] + user['section']),
          Text(user['bio']),
        ],
      ),
    );
  }
}
