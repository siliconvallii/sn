import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn/providers/silent_email_sign_in.dart';
import 'package:sn/utils/fetch_data.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(flex: 4),
              Text(
                'eeloo',
                style: GoogleFonts.alata(
                  color: Colors.white,
                  fontSize: 48,
                ),
              ),
              const Spacer(flex: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('accedi'),
        onPressed: () async {
          Map userData = await fetchData(context);

          if (userData['email'] != '' && userData['password'] != '') {
            await silentEmailSignIn(
              context,
              userData['email'],
              userData['password'],
            );
          } else {
            Navigator.pushNamed(context, '/sign_in');
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
