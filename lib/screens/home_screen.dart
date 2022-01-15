import 'package:flutter/material.dart';
import 'package:sn/providers/fetch_chats.dart';
import 'package:sn/providers/sign_in.dart';
import 'package:sn/widgets/start_chat_button.dart';
import 'package:sn/widgets/user_has_to_reply_card.dart';
import 'package:sn/widgets/user_replied_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('SN'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: fetchChats(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                // snapshot is waiting
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      const StartChatButton(),
                      (snapshot.hasError)
                          // snapshot has error
                          ? const Text('Non hai messaggi.')
                          // snapshot has data
                          : ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                if (snapshot.data!['index']['sender'] ==
                                    user['uid']) {
                                  // user replied last
                                  return UserRepliedCard(
                                    chatData: snapshot.data![index],
                                  );
                                } else {
                                  // user has to reply
                                  return UserHasToReplyCard(
                                    chatData: snapshot.data![index],
                                  );
                                }
                              },
                            ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
