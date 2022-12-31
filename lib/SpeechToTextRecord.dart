// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

class STTR extends StatefulWidget {
  @override
  State<STTR> createState() => _STTRState();
}

class _STTRState extends State<STTR> {
  bool _hasSpeech = false;
  bool _logEvents = false;
  bool _isListening = false;
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  SpeechToText _speechToText = SpeechToText();
  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    try {
      var hasSpeech = await _speechToText.initialize(
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        _localeNames = await _speechToText.locales();
        var systemLocale = await _speechToText.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
    } catch (e) {
      setState(() {
        _hasSpeech = false;
      });
    }
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Color.fromARGB(255, 68, 84, 106),
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          focusElevation: 20,
          backgroundColor: Color.fromARGB(255, 68, 84, 106),
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 80.0),
                  child: Text(
                    _text,
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 40, top: 30),
                child: Row(
                  children: [
                    Text('Language: '),
                    DropdownButton<String>(
                      onChanged: (selectedVal) => _switchLang(selectedVal),
                      value: _currentLocaleId,
                      items: _localeNames
                          .map(
                            (localeName) => DropdownMenuItem(
                              value: localeName.localeId,
                              child: Text(localeName.name),
                            ),
                          )
                          .toList(),
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
          localeId: _currentLocaleId,
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }
}
