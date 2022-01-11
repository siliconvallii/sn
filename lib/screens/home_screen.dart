import 'package:flutter/material.dart';
import 'package:sn/pages/inbox_page.dart';
import 'package:sn/pages/own_profile_page.dart';
import 'package:sn/pages/send_image_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('SN'),
      ),
      body: _index == 0
          ? const InboxPage()
          : _index == 1
              ? const SendImagePage()
              : const OwnProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (int index) => setState(() {
          _index = index;
        }),
      ),
    );
  }
}
