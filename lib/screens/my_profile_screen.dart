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
    );
  }
}
