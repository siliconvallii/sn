import 'package:flutter/material.dart';

class WatchImageScreen extends StatelessWidget {
  final String imageUrl;
  const WatchImageScreen({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SN'),
      ),
      body: SafeArea(
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
