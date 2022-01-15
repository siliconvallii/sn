import 'package:flutter/material.dart';
import 'package:sn/providers/fetch_user_data.dart';

class UserHasToReplyCard extends StatelessWidget {
  final Map chatData;
  const UserHasToReplyCard({required this.chatData, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserData(chatData['sender']),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            // snapshot is waiting
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  SizedBox(
                    child: Image.network(
                      snapshot.data['profile_picture'],
                    ),
                    height: 50,
                  ),
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
