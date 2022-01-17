import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn/providers/sign_in.dart';
import 'package:sn/providers/upload_image.dart';
import 'package:sn/utils/crop_image_to_square.dart';
import 'package:sn/utils/pick_image.dart';
import 'package:sn/utils/take_image.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({Key? key}) : super(key: key);

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  final String _templateImageUrl =
      'https://img.myloview.it/quadri/upload-vector-icon-cloud-storage-symbol-upload-to-cloud-icon-modern-simple-line-style-vector-illustration-for-web-site-or-mobile-app-700-176322192.jpg';
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
          'nuova chat',
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
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: user['username'],
                                  style: GoogleFonts.alata(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'a: ',
                                style: GoogleFonts.alata(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: TextField(
                                    controller: _recipientController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'destinatario...',
                                      hintStyle: GoogleFonts.alata(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                    style: GoogleFonts.alata(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: _marginSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      margin: EdgeInsets.all(
                        _marginSize,
                      ),
                    ),
                    SizedBox(
                      child: _image == null
                          ? Image.network(_templateImageUrl)
                          : Image.file(_image!),
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'scrivi messaggio...',
                          hintStyle: GoogleFonts.alata(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: GoogleFonts.alata(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: _marginSize,
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

                      // find user with username
                      Map recipientData = {};

                      await ref
                          .child('users')
                          .get()
                          .then((DataSnapshot snapshot) async {
                        dynamic allUsers = snapshot.value;
                        await allUsers.forEach((key, value) {
                          if (value['username'] == _recipientController.text) {
                            recipientData = value;
                          }
                        });
                      });

                      // check if user was found
                      if (recipientData == {}) {
                        // user wasn't found

                        // show error
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('errore!'),
                              content: Text(
                                'sembra che l\'utente ${_recipientController.text} non esista',
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
                      } else if (recipientData['uid'] == user['uid']) {
                        // user is trying to message imself

                        // show error
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('errore!'),
                              content: const Text(
                                'non puoi scrivere a te stesso!',
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
                        // user was found

                        String chatKey = user['uid'] + recipientData['uid'];

                        // check if chat already exists
                        await ref.child('chats').get().then((snapshot) async {
                          // fetch all chats
                          dynamic _allChatsMap = snapshot.value;

                          await _allChatsMap.forEach((key, value) {
                            // check if users are involved in each chat
                            if (key.contains(user['uid']) &&
                                key.contains(recipientData['uid'])) {
                              // users are involved

                              // overwrite chatKey with existing chat key
                              chatKey = key;
                            }
                          });
                        });

                        // check if chat already exists
                        await ref.child('chats').get().then((snapshot) async {
                          // fetch all chats
                          dynamic _allChatsMap = snapshot.value;

                          await _allChatsMap.forEach((key, value) {
                            // check if users are involved in each chat
                            if (key.contains(user['uid']) &&
                                key.contains(recipientData['uid'])) {
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
                          'recipient': recipientData['uid'],
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
