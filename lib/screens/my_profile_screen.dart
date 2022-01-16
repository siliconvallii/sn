import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  final Map profile;
  const MyProfileScreen({required this.profile, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          profile['username'],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    child: Image.network(
                      profile['profile_picture'],
                    ),
                    height: 100,
                  ),
                  Column(
                    children: [
                      Text('${profile['total_friends']} amici'),
                      ElevatedButton(
                        child: const Text('Modifica profilo'),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              Text(profile['username']),
              Text('Liceo Sarpi - ${profile['class']}${profile['section']}'),
              Text(profile['bio']),
            ],
          ),
        ),
      ),
    );
  }
}