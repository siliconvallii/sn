import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn/data/user_data.dart';
import 'package:sn/providers/fetch_chats.dart';
import 'package:sn/screens/my_profile_screen.dart';
import 'package:sn/widgets/start_chat_button.dart';
import 'package:sn/widgets/user_has_to_reply_card.dart';
import 'package:sn/widgets/user_replied_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MyProfileScreen(profile: user),
                  ),
                );
              },
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff2E2E2E),
          centerTitle: true,
          elevation: 0,
          title: Text(
            'eeloo',
            style: GoogleFonts.alata(
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: const Color(0xff121212),
        body: SafeArea(
          child: FutureBuilder(
            future: fetchChats(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  // snapshot is waiting
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffBC91F8),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await fetchChats();
                        setState(() {});
                      },
                      child: (snapshot.hasError)
                          // snapshot has error
                          ? Text(snapshot.error.toString())
                          // snapshot has data
                          : ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (snapshot.data![index]['sender'] ==
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
                    );
            },
          ),
        ),
        floatingActionButton: const StartChatButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      onWillPop: () async => false,
    );
  }
}
