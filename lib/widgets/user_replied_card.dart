import 'package:flutter/material.dart';
import 'package:sn/providers/fetch_user_data.dart';

class UserRepliedCard extends StatelessWidget {
  final Map chatData;
  const UserRepliedCard({required this.chatData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserData(chatData['recipient']),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Row(
          children: [
            Image.network(snapshot.data['profile_picture']),
            Column(
              children: [
                Text(snapshot.data['username']),
                Text(
                  'Hai risposto ' +
                      DateTime.now()
                          .difference(DateTime.parse(chatData['sent_at']))
                          .inHours
                          .toString() +
                      ' ore fa',
                ),
              ],
            ),
            const Icon(Icons.arrow_upward),
          ],
        );
      },
    );
  }
}
