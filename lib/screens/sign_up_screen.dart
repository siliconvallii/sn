import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn/providers/create_profile.dart';
import 'package:sn/utils/crop_image_to_square.dart';
import 'package:sn/utils/pick_image.dart';
import 'package:sn/utils/take_image.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _dropdownValue = 'I';
  String _secondDropdownValue = 'A';

  final String _templateImageUrl =
      'https://img.myloview.it/quadri/upload-vector-icon-cloud-storage-symbol-upload-to-cloud-icon-modern-simple-line-style-vector-illustration-for-web-site-or-mobile-app-700-176322192.jpg';
  File? _profileImage;

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _marginSize = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2E2E2E),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'completa il tuo profilo',
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
                                  text: 'ciao!\n',
                                  style: GoogleFonts.alata(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'completa il tuo profilo per continuare',
                                  style: GoogleFonts.alata(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
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
                      child: _profileImage == null
                          ? Image.network(_templateImageUrl)
                          : Image.file(_profileImage!),
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
                          _profileImage = image;
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
                          _profileImage = image;
                        });
                      },
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            'classe:',
                            style: GoogleFonts.alata(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          Container(
                            child: DropdownButton<String>(
                              dropdownColor: const Color(0xff2E2E2E),
                              items: const [
                                DropdownMenuItem(
                                  child: Text('I'),
                                  value: 'I',
                                ),
                                DropdownMenuItem(
                                  child: Text('II'),
                                  value: 'II',
                                ),
                                DropdownMenuItem(
                                  child: Text('III'),
                                  value: 'III',
                                ),
                                DropdownMenuItem(
                                  child: Text('IV'),
                                  value: 'IV',
                                ),
                                DropdownMenuItem(
                                  child: Text('V'),
                                  value: 'V',
                                ),
                              ],
                              onChanged: (newValue) => setState(() {
                                _dropdownValue = newValue.toString();
                              }),
                              style: GoogleFonts.alata(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                              value: _dropdownValue,
                            ),
                            margin: EdgeInsets.only(left: _marginSize),
                          ),
                          Container(
                            child: DropdownButton<String>(
                              dropdownColor: const Color(0xff2E2E2E),
                              items: const [
                                DropdownMenuItem(
                                  child: Text('A'),
                                  value: 'A',
                                ),
                                DropdownMenuItem(
                                  child: Text('B'),
                                  value: 'B',
                                ),
                                DropdownMenuItem(
                                  child: Text('C'),
                                  value: 'C',
                                ),
                                DropdownMenuItem(
                                  child: Text('D'),
                                  value: 'D',
                                ),
                                DropdownMenuItem(
                                  child: Text('E'),
                                  value: 'E',
                                ),
                                DropdownMenuItem(
                                  child: Text('F'),
                                  value: 'F',
                                ),
                                DropdownMenuItem(
                                  child: Text('G'),
                                  value: 'G',
                                ),
                                DropdownMenuItem(
                                  child: Text('H'),
                                  value: 'H',
                                ),
                                DropdownMenuItem(
                                  child: Text('I'),
                                  value: 'I',
                                ),
                                DropdownMenuItem(
                                  child: Text('L'),
                                  value: 'L',
                                ),
                                DropdownMenuItem(
                                  child: Text('M'),
                                  value: 'M',
                                ),
                              ],
                              onChanged: (newValue) => setState(() {
                                _secondDropdownValue = newValue.toString();
                              }),
                              style: GoogleFonts.alata(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                              value: _secondDropdownValue,
                            ),
                            margin: EdgeInsets.only(left: _marginSize),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(_marginSize),
                    ),
                    Container(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'scrivi una breve bio...',
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
              ElevatedButton(
                child: const Text('completa registrazione'),
                onPressed: () async {
                  // check if there are image and text
                  if (_profileImage == null) {
                    // image is missing
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('errore!'),
                          content: const Text(
                            'devi inserire un\'immagine per il tuo profilo',
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
                            'devi scrivere una bio per il tuo profilo',
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

                    // create profile & navigate to HomeScreen
                    createProfile(
                      context,
                      _profileImage,
                      _dropdownValue,
                      _secondDropdownValue,
                      _textController.text,
                    );

                    // pop loading indicator
                    Navigator.pop(context);
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
            ],
          ),
        ),
      ),
    );
  }
}
