import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Voice extends StatefulWidget {
  const Voice({super.key});
  static const routeName = '/Voice';
  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  final FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    _fetchVoices();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  List<dynamic>? voices;
  dynamic voice;

  Future<void> _fetchVoices() async {
    voice = await flutterTts.getVoices;
    setState(() {});
  }

  Future<void> _speak() async {
    if (textController.text.isNotEmpty) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(6);
      await flutterTts.setSpeechRate(0.4);

      await flutterTts.speak(textController.text);
    }
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Speech'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Enter text to speak',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speak,
              child: const Text('Speak'),
            ),
            ElevatedButton(
              onPressed: _stop,
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}
