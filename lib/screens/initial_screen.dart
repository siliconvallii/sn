import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn/providers/sign_in.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _imageSize = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(flex: 4),
              SizedBox(
                child: Image.asset('assets/images/initial_screen_image.png'),
                height: _imageSize,
                width: _imageSize,
              ),
              Text(
                'eeloo',
                style: GoogleFonts.alata(
                  color: Colors.white,
                  fontSize: 48,
                ),
              ),
              const Spacer(flex: 10),
              ElevatedButton(
                child: const Text('entra con Google'),
                onPressed: () => signIn(context),
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
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
