import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Nuova chat'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Da: ${user['username']}'),
              const Text('A:'),
              TextField(
                controller: _recipientController,
              ),
              TextButton(
                child: const Text('Prendi immagine dalla libreria'),
                onPressed: () async {
                  // take image
                  XFile? tempImage = await takeImage();

                  // crop image to square
                  File? image = await cropImageToSquare(tempImage!);

                  // initialize image
                  _image = image;
                },
              ),
              TextButton(
                child: const Text('Scatta fotografia'),
                onPressed: () async {
                  // pick image
                  XFile? tempImage = await pickImage();

                  // crop image to square
                  File? image = await cropImageToSquare(tempImage!);

                  // initialize image
                  _image = image;
                },
              ),
              TextField(
                controller: _textController,
              ),
              ElevatedButton(
                child: const Text('Avvia chat'),
                onPressed: () async {
                  // instatiate reference of Realtime Database
                  final DatabaseReference ref = FirebaseDatabase.instance.ref();

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
                          title: const Text('Errore!'),
                          content: Text(
                            'Sembra che l\'utente ${_recipientController.text} non esista',
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
                          title: const Text('Errore!'),
                          content: const Text(
                            'Non puoi scrivere a te stesso!',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
