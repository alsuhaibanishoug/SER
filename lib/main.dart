// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'SpeechToTextRecord.dart';
import 'TextToSpeech.dart';

void main() {
  runApp(const SaghiApp());
}

class SaghiApp extends StatelessWidget {
  const SaghiApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  final pages = [
    TTS(),
    STTR(),
    Center(
      child: Text(
        'Account',
        style: TextStyle(fontSize: 50),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10,
        ),
        child: GNav(
          color: Color.fromARGB(255, 68, 84, 106),
          activeColor: Color.fromARGB(255, 253, 102, 24),
          iconSize: 35,
          gap: 4,
          tabs: const [
            GButton(
              icon: Icons.campaign,
              text: 'Text To Speech',
            ),
            GButton(
              icon: Icons.mic_rounded,
              text: 'Speech To Text',
            ),
            GButton(
              icon: Icons.person_rounded,
              text: 'Account',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(
              () {
                _selectedIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}
