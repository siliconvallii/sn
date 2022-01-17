import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn/providers/fetch_user_data.dart';
import 'package:sn/screens/profile_screen.dart';

class UserRepliedCard extends StatelessWidget {
  final Map chatData;
  const UserRepliedCard({required this.chatData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserData(chatData['recipient']),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            // snapshot is waiting
            ? const Center(child: CircularProgressIndicator())
            : Container(
                child: Row(
                  children: [
                    InkWell(
                      child: SizedBox(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            errorWidget: (BuildContext context, String url,
                                    dynamic error) =>
                                const Icon(Icons.error),
                            imageUrl: snapshot.data['profile_picture'],
                            placeholder: (BuildContext context, String url) =>
                                const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffBC91F8),
                              ),
                            ),
                          ),
                        ),
                        height: 50,
                        width: 50,
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
                    Container(
                      child: Column(
                        children: [
                          Text(
                            snapshot.data['username'],
                            style: GoogleFonts.alata(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            'hai risposto ' +
                                DateTime.now()
                                    .difference(
                                        DateTime.parse(chatData['sent_at']))
                                    .inHours
                                    .toString() +
                                ' ore fa',
                            style: GoogleFonts.alata(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      margin: const EdgeInsets.only(
                        left: 10,
                      ),
                    ),
                  ],
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff1E1E1E),
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
              );
      },
    );
  }
}
