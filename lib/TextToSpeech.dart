// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTS extends StatefulWidget {
  @override
  State<TTS> createState() => _TTSState();
}

class _TTSState extends State<TTS> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController controller = TextEditingController();

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  List<String>? languages;
  String langCode = "en-US";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    languages = List<String>.from(await flutterTts.getLanguages);
    setState(() {});
  }

  void initSetting() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
  }

  void _speak() async {
    initSetting();
    await flutterTts.speak(controller.text);
  }

  void _stop() async {
    await flutterTts.stop();
  }

  void _arab() async {
    langCode = "ar-001";
  }

  void _eng() async {
    langCode = "en-US";
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed) |
          states.contains(MaterialState.hovered)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 350,
                      height: 60,
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Text',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min, // from here
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: const Text("Speak"),
                    onPressed: _speak,
                    style: ButtonStyle(
                        backgroundColor: getColor(
                            Color.fromARGB(255, 68, 84, 106),
                            Color.fromARGB(255, 253, 102, 24))),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: const Text("Stop"),
                    onPressed: _stop,
                    style: ButtonStyle(
                        backgroundColor: getColor(
                            Color.fromARGB(255, 68, 84, 106),
                            Color.fromARGB(255, 253, 102, 24))),
                  ),
                ],
              ),
              if (languages != null)
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 20),
                  child: Row(
                    children: [
                      const Text(
                        "Language :",
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        child: const Text("AR"),
                        onPressed: _arab,
                        style: ButtonStyle(
                            foregroundColor: getColor(
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(255, 255, 255, 255)),
                            backgroundColor: getColor(
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 253, 102, 24))),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        child: const Text("EN"),
                        onPressed: _eng,
                        style: ButtonStyle(
                            foregroundColor: getColor(
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(255, 255, 255, 255)),
                            backgroundColor: getColor(
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 253, 102, 24))),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
