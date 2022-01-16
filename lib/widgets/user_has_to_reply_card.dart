import 'package:flutter/material.dart';
import 'package:sn/providers/fetch_user_data.dart';
import 'package:sn/screens/chat_screen.dart';
import 'package:sn/screens/profile_screen.dart';

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
                  InkWell(
                    child: SizedBox(
                      child: Image.network(
                        snapshot.data['profile_picture'],
                      ),
                      height: 50,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProfileScreen(
                            profile: snapshot.data,
                          ),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Text(snapshot.data['username']),
                        Text(
                          'Ti ha scritto ' +
                              DateTime.now()
                                  .difference(
                                      DateTime.parse(chatData['sent_at']))
                                  .inHours
                                  .toString() +
                              ' ore fa',
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ChatScreen(
                            chatData: chatData,
                            senderData: snapshot.data,
                          ),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    child: const Icon(Icons.arrow_right_alt),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ChatScreen(
                            chatData: chatData,
                            senderData: snapshot.data,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
      },
    );
  }
}
