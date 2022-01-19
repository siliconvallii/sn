import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn/screens/delete_account_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _marginSize = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2E2E2E),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'impostazioni',
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
                    Text(
                      'contatti',
                      style: GoogleFonts.alata(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '\nil tuo parere è importante! usa i contatti '
                      'che trovi qui sotto per segnalare bug, suggerire '
                      'modifiche o per fare una domanda. grazie!\n',
                      style: GoogleFonts.alata(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'filippo.valli@studenti.liceosarpi.bg.it\n',
                      style: GoogleFonts.alata(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'oppure scrivimi qua, filippo.valli 😽',
                      style: GoogleFonts.alata(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff1E1E1E),
                ),
                margin: EdgeInsets.only(
                  left: _marginSize,
                  right: _marginSize,
                  top: _marginSize,
                ),
                padding: const EdgeInsets.all(10),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      'privacy',
                      style: GoogleFonts.alata(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '\ncon eeloo i tuoi dati sono al sicuro. i pochi dati che'
                      ' raccogliamo sono strettamente necessari per il '
                      'funzionamento dell\'applicazione e le tue informazioni '
                      'private sono conservate nei nostri database. nessuna '
                      'terza parte ha accesso ai database di eeloo. '
                      'i tuoi dati sensibili sono criptati prima di essere '
                      'memorizzati, affinché nemmeno gli sviluppatori possano '
                      'entrare in possesso dei tuoi dati.',
                      style: GoogleFonts.alata(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff1E1E1E),
                ),
                margin: EdgeInsets.only(
                  left: _marginSize,
                  right: _marginSize,
                  top: _marginSize,
                ),
                padding: const EdgeInsets.all(10),
              ),
              Container(
                child: InkWell(
                  child: Row(
                    children: [
                      Text(
                        'elimina il mio account',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.alata(
                          color: const Color(0xffBF4343),
                          fontSize: 17,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xffBF4343),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeleteAccountScreen(),
                      ),
                    );
                  },
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff1E1E1E),
                ),
                margin: EdgeInsets.only(
                  left: _marginSize,
                  right: _marginSize,
                  top: _marginSize,
                ),
                padding: const EdgeInsets.all(10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
