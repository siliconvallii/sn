import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sn/providers/fetch_inbox.dart';
import 'package:sn/providers/send_image.dart';
import 'package:sn/providers/sign_in.dart';
import 'package:sn/screens/watch_image_screen.dart';
import 'package:sn/utils/take_image.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    // instatiate reference of Realtime Database
    final DatabaseReference ref = FirebaseDatabase.instance.ref();

    return FutureBuilder(
      future: fetchInbox(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RefreshIndicator(
          onRefresh: () async {
            await fetchInbox();
            setState(() {});
          },
          child: (snapshot.connectionState == ConnectionState.waiting)
              ? ListView(
                  children: const [
                    CircularProgressIndicator(),
                  ],
                )
              : (snapshot.hasError)
                  ? ListView(
                      children: const [Text('Non hai messaggi.')],
                    )
                  : ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.data[index]['replied_at'] != null) {
                          return Row(
                            children: [
                              Image.network(
                                snapshot.data![index]['sender']
                                    ['profile_picture'],
                                scale: 10,
                              ),
                              Column(
                                children: [
                                  Text(snapshot.data![index]['sender']
                                      ['username']),
                                  Text(
                                    'Hai risposto ' +
                                        DateTime.now()
                                            .difference(DateTime.parse(snapshot
                                                .data![index]['replied_at']))
                                            .inHours
                                            .toString() +
                                        ' ore fa',
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (snapshot.data[index]['viewed']) {
                          return InkWell(
                            child: Row(
                              children: [
                                Image.network(
                                  snapshot.data![index]['sender']
                                      ['profile_picture'],
                                  scale: 10,
                                ),
                                Column(
                                  children: [
                                    Text(snapshot.data![index]['sender']
                                        ['username']),
                                    Text('Rispondi entro ' +
                                        (24 -
                                                DateTime.now()
                                                    .difference(DateTime.parse(
                                                        snapshot.data![index]
                                                            ['date']))
                                                    .inHours)
                                            .toString() +
                                        ' ore'),
                                  ],
                                ),
                                const Icon(Icons.arrow_upward),
                              ],
                            ),
                            onTap: () async {
                              String imageUrl = await takeImage();
                              sendImage(imageUrl,
                                  snapshot.data![index]['sender']['uid']);
                              await ref
                                  .child('inboxes')
                                  .child(user['uid'])
                                  .child(snapshot.data![index]['sender']['uid'])
                                  .child('replied_at')
                                  .set(DateTime.now().toUtc().toString())
                                  .then((value) => setState(() {}));
                            },
                          );
                        } else {
                          return InkWell(
                            child: Row(
                              children: [
                                Image.network(
                                  snapshot.data![index]['sender']
                                      ['profile_picture'],
                                  scale: 10,
                                ),
                                Column(
                                  children: [
                                    Text(snapshot.data![index]['sender']
                                        ['username']),
                                    Text(
                                      'Inviata ' +
                                          DateTime.now()
                                              .difference(DateTime.parse(
                                                  snapshot.data![index]
                                                      ['date']))
                                              .inHours
                                              .toString() +
                                          ' ore fa',
                                    )
                                  ],
                                ),
                                const Icon(Icons.arrow_downward),
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WatchImageScreen(
                                    imageUrl: snapshot.data![index]['image'],
                                  ),
                                ),
                              ).then((value) => setState(() {}));
                              await ref
                                  .child('inboxes')
                                  .child(user['uid'])
                                  .child(snapshot.data![index]['sender']['uid'])
                                  .child('viewed')
                                  .set(true);
                            },
                          );
                        }
                      },
                    ),
        );
      },
    );
  }
}
