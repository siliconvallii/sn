import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sn/providers/create_profile.dart';
import 'package:sn/utils/pick_profile_image.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _dropdownValue = 'I';
  String _secondDropdownValue = 'A';
  File? _profileImage;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Ciao!\nCompleta il tuo profilo per continuare'),
                _profileImage != null
                    ? Image.file(_profileImage!)
                    : Image.asset('assets/images/default_pp.jpg'),
                TextButton(
                  onPressed: () async {
                    File? profileImage = await pickProfileImage();
                    setState(() {
                      _profileImage = profileImage;
                    });
                  },
                  child: _profileImage != null
                      ? const Text('Cambia immagine profilo')
                      : const Text('Carica immagine profilo'),
                ),
                Row(
                  children: [
                    const Text('Classe:'),
                    DropdownButton<String>(
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
                      value: _dropdownValue,
                    ),
                    DropdownButton<String>(
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
                      value: _secondDropdownValue,
                    ),
                  ],
                ),
                const Text('Bio:'),
                TextField(
                  controller: _textEditingController,
                ),
                ElevatedButton(
                  onPressed: () async {
                    createProfile(
                      context,
                      _profileImage,
                      _dropdownValue,
                      _secondDropdownValue,
                      _textEditingController.text,
                    );
                  },
                  child: const Text('Completa registrazione'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
