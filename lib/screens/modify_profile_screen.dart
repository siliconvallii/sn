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

class ModifyProfileScreen extends StatefulWidget {
  final Map profile;
  const ModifyProfileScreen({required this.profile, Key? key})
      : super(key: key);

  @override
  State<ModifyProfileScreen> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  File? _image;

  @override
  Widget build(BuildContext context) {
    double _imageSize = MediaQuery.of(context).size.width * 0.3;
    double _marginSize = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2E2E2E),
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.profile['username'],
          style: GoogleFonts.alata(),
        ),
      ),
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _image == null
                            ? CachedNetworkImage(
                                fit: BoxFit.fill,
                                errorWidget: (BuildContext context, String url,
                                        dynamic error) =>
                                    const Icon(Icons.error),
                                imageUrl: widget.profile['profile_picture'],
                                placeholder:
                                    (BuildContext context, String url) =>
                                        const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xffBC91F8),
                                  ),
                                ),
                              )
                            : Image.file(
                                _image!,
                                fit: BoxFit.fill,
                              ),
                      ),
                      height: _imageSize,
                      width: _imageSize,
                    ),
                    const Spacer(flex: 2),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    widget.profile['total_friends'].toString(),
                                    style: GoogleFonts.alata(
                                      color: Colors.white,
                                      fontSize: 21,
                                    ),
                                  ),
                                  Text(
                                    'amici',
                                    style: GoogleFonts.alata(
                                      color: Colors.grey,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.only(right: 20),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    widget.profile['class'],
                                    style: GoogleFonts.alata(
                                      color: Colors.white,
                                      fontSize: 21,
                                    ),
                                  ),
                                  Text(
                                    'classe',
                                    style: GoogleFonts.alata(
                                      color: Colors.grey,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.only(right: 20),
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.profile['section'],
                                  style: GoogleFonts.alata(
                                    color: Colors.white,
                                    fontSize: 21,
                                  ),
                                ),
                                Text(
                                  'sezione',
                                  style: GoogleFonts.alata(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          child: Text(
                            'prendi immagine dalla libreria',
                            style: GoogleFonts.alata(
                              color: const Color(0xffBC91F8),
                              fontSize: 14,
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
                              fontSize: 14,
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
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    const Spacer(),
                  ],
                ),
                Container(
                  child: TextField(
                    controller: _usernameController,
                    cursorColor: const Color(0xffBC91F8),
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
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
                      hintText: 'username...',
                      hintStyle: GoogleFonts.alata(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    style: GoogleFonts.alata(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: _marginSize,
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _bioController,
                    cursorColor: const Color(0xffBC91F8),
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
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
                      hintText: 'scrivi una breve bio...',
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
            margin: EdgeInsets.symmetric(
              horizontal: _marginSize,
              vertical: _marginSize,
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('conferma modifiche'),
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
          } else if (_usernameController.text == '' ||
              _bioController.text == '') {
            // text is missing
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('errore!'),
                  content: const Text(
                    'devi inserire un username e una bio',
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
            final DatabaseReference ref = FirebaseDatabase.instance.ref();

            // upload image
            String imageUrl = await uploadImage(_image!);

            // update username
            await ref
                .child('users')
                .child(user['uid'])
                .child('username')
                .set(_usernameController.text);

            // update bio
            await ref
                .child('users')
                .child(user['uid'])
                .child('bio')
                .set(_bioController.text);

            // update profile_picture
            await ref
                .child('users')
                .child(user['uid'])
                .child('profile_picture')
                .set(imageUrl);

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
                  title: const Text('fatto!'),
                  content: const Text(
                    'profilo modificato con successo! se non vedi le modifiche prova a riavviare l\'app',
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
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xff63D7C6),
          ),
          foregroundColor: MaterialStateProperty.all(
            const Color(0xff121212),
          ),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.alata(
              fontSize: 14,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
