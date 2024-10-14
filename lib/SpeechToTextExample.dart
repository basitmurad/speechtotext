import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class SpeechToTextExample extends StatefulWidget {
  @override
  _SpeechToTextExampleState createState() => _SpeechToTextExampleState();
}

class _SpeechToTextExampleState extends State<SpeechToTextExample> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the MIC and speak';
  final int maxListeningTime = 6; // Maximum time for speech input in seconds
  final int maxWaitTime = 5; // Maximum waiting time for speech to start

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Start listening to the user's speech
  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords; // Display the recognized words
        }),
        listenFor: Duration(seconds: maxListeningTime), // Max speaking time
        pauseFor: Duration(seconds: maxWaitTime), // Max waiting time for speech
        partialResults: false, // Disable partial results
      );
    }
  }

  // Stop listening
  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _text,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              iconSize: 50,
              onPressed: _isListening ? _stopListening : _startListening,
            ),
          ],
        ),
      ),
    );
  }
}
