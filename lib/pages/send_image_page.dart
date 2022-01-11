import 'package:flutter/material.dart';
import 'package:sn/providers/send_to_random.dart';
import 'package:sn/utils/take_image.dart';

class SendImagePage extends StatelessWidget {
  const SendImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              String imageUrl = await takeImage();
              sendToRandom(imageUrl);
            },
            child: const Text('Send to random'),
          ),
        ],
      ),
    );
  }
}
