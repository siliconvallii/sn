import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn/data/user_data.dart';
import 'package:sn/providers/upload_image.dart';
import 'package:sn/utils/crop_image_to_square.dart';
import 'package:sn/utils/pick_image.dart';
import 'package:sn/utils/take_image.dart';

class ChatScreen extends StatefulWidget {
  final Map chatData;
  final Map senderData;
  const ChatScreen({required this.chatData, required this.senderData, Key? key})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  File? _image;

  @override
  Widget build(BuildContext context) {
    double _marginSize = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2E2E2E),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'chat con ${widget.senderData['username']}',
          style: GoogleFonts.alata(),
        ),
      ),
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'da: ',
                                  style: GoogleFonts.alata(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.senderData['username'],
                                  style: GoogleFonts.alata(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'a: ',
                                  style: GoogleFonts.alata(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: user['username'],
                                  style: GoogleFonts.alata(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      margin: EdgeInsets.all(
                        _marginSize,
                      ),
                    ),
                    SizedBox(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        errorWidget:
                            (BuildContext context, String url, dynamic error) =>
                                const Icon(Icons.error),
                        imageUrl: widget.chatData['image'],
                        placeholder: (BuildContext context, String url) =>
                            const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffBC91F8),
                          ),
                        ),
                      ),
                      width: double.infinity,
                    ),
                    Container(
                      child: Text(
                        widget.chatData['text'],
                        style: GoogleFonts.alata(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      margin: EdgeInsets.all(
                        _marginSize,
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Color(0xff1E1E1E),
                ),
                margin: EdgeInsets.all(_marginSize),
              ),
              Container(
                child: Text(
                  'rispondi a ${widget.senderData['username']}',
                  style: GoogleFonts.alata(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
                margin: EdgeInsets.all(
                  _marginSize,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'da: ',
                                  style: GoogleFonts.alata(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: user['username'],
                                  style: GoogleFonts.alata(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'a: ',
                                  style: GoogleFonts.alata(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.senderData['username'],
                                  style: GoogleFonts.alata(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      margin: EdgeInsets.all(
                        _marginSize,
                      ),
                    ),
                    SizedBox(
                      child: _image == null ? Container() : Image.file(_image!),
                      width: double.infinity,
                    ),
                    TextButton(
                      child: Text(
                        'prendi immagine dalla libreria',
                        style: GoogleFonts.alata(
                          color: const Color(0xffBC91F8),
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () async {
                        // take image
                        XFile? tempImage = await takeImage();

                        // crop image to square
                        File? image = await cropImageToSquare(tempImage!);

                        // initialize image
                        setState(() {
                          _image = image;
                        });
                      },
                    ),
                    TextButton(
                      child: Text(
                        'scatta fotografia',
                        style: GoogleFonts.alata(
                          color: const Color(0xffBC91F8),
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () async {
                        // pick image
                        XFile? tempImage = await pickImage();

                        // crop image to square
                        File? image = await cropImageToSquare(tempImage!);

                        // initialize image
                        setState(() {
                          _image = image;
                        });
                      },
                    ),
                    Container(
                      child: TextField(
                        controller: _textController,
                        cursorColor: const Color(0xffBC91F8),
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          counterText: '',
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          hintText: 'scrivi messaggio...',
                          hintStyle: GoogleFonts.alata(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLength: 200,
                        maxLines: null,
                        style: GoogleFonts.alata(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      margin: EdgeInsets.only(
                        bottom: _marginSize,
                        left: _marginSize,
                        right: _marginSize,
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Color(0xff1E1E1E),
                ),
                margin: EdgeInsets.all(_marginSize),
              ),
              Container(
                child: ElevatedButton(
                  child: const Text('invia messaggio'),
                  onPressed: () async {
                    // check if there are image and text
                    if (_image == null) {
                      // image is missing
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('errore!'),
                            content: const Text(
                              'devi inserire un\'immagine per inviare',
                            ),
                            actions: <TextButton>[
                              TextButton(
                                child: const Text('ok'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (_textController.text == '') {
                      // text is missing
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('errore!'),
                            content: const Text(
                              'devi scrivere un messaggio per inviare',
                            ),
                            actions: <TextButton>[
                              TextButton(
                                child: const Text('ok'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // dismiss keyboard
                      FocusManager.instance.primaryFocus?.unfocus();

                      // show loading indicator
                      showDialog(
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        context: context,
                      );

                      // instatiate reference of Realtime Database
                      final DatabaseReference ref =
                          FirebaseDatabase.instance.ref();

                      String chatKey = user['uid'] + widget.senderData['uid'];

                      // check if chat already exists
                      await ref.child('chats').get().then((snapshot) async {
                        // fetch all chats
                        dynamic _allChatsMap = snapshot.value;

                        await _allChatsMap.forEach((key, value) {
                          // check if users are involved in each chat
                          if (key.contains(user['uid']) &&
                              key.contains(widget.senderData['uid'])) {
                            // users are involved

                            // overwrite chatKey with existing chat key
                            chatKey = key;
                          }
                        });
                      });

                      // upload image
                      String imageUrl = await uploadImage(_image!);

                      Map chatMap = {
                        'image': imageUrl,
                        'text': _textController.text,
                        'sender': user['uid'],
                        'sent_at': DateTime.now().toString(),
                        'recipient': widget.senderData['uid'],
                      };

                      // upload message to chat
                      await ref
                          .child('chats')
                          .child(chatKey)
                          .set(chatMap)
                          .then((value) {
                        // pop loading indicator
                        Navigator.pop(context);

                        // navigate back to HomeScreen
                        Navigator.pushNamed(context, '/home').then(
                          (value) => setState(() {}),
                        );

                        // show successful dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Fatto!'),
                              content: const Text(
                                'Messaggio inviato con successo!',
                              ),
                              actions: <TextButton>[
                                TextButton(
                                  child: const Text('Ok'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          },
                        );
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xff63D7C6),
                    ),
                    foregroundColor:
                        MaterialStateProperty.all(const Color(0xff121212)),
                    textStyle: MaterialStateProperty.all(
                      GoogleFonts.alata(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(
                  bottom: _marginSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
