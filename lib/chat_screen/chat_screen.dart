import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tflite_flutter/tflite_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/ChatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FlutterTts flutterTts = FlutterTts();

  bool _hasSpeech = false;
  bool _logEvents = false;
  bool _onDevice = false;
  final TextEditingController _pauseForController =
      TextEditingController(text: '3');
  final TextEditingController _listenForController =
      TextEditingController(text: '30');
  double level = 0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  bool resultData = false;
  // List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  List<dynamic>? voices;
  dynamic voice;
  late IsolateInterpreter isolateInterpreter =
      IsolateInterpreter as IsolateInterpreter;
  Future<void> fetchVoices() async {
    voice = await flutterTts.getVoices;
    setState(() {});
  }

  Future<void> speak({required String lastWords}) async {
    if (lastWords.isNotEmpty) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.4);

      await flutterTts.speak(lastWords);
    }
  }

  @override
  void initState() {
    super.initState();
    initAsync();

    check();
    initSpeechState();

    requestMicrophonePermission();
  }

  Future<void> initAsync() async {
    final interpreter =
        await Interpreter.fromAsset('assets/models/mobilenet_float_v1_224.tflite');
    isolateInterpreter =
        await IsolateInterpreter.create(address: interpreter.address);
  }

  getResponse(
    String inPut,
    String outPut,
  ) {
    isolateInterpreter.run(inPut, outPut);
    print('---->$outPut');
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      final hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        // _localeNames = await speech.locales();
        final systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: $e';
        _hasSpeech = false;
      });
    }
  }

  Future<void> check() async {
    var speech = stt.SpeechToText();
    bool available = await speech.initialize(
        onStatus: statusListener, onError: errorListener);
    if (available) {
      speech.listen(onResult: resultListener);
    } else {
      print("The user has denied the use of speech recognition.");
    }
    // some time later...
    speech.stop();
  }

  Future<bool> requestMicrophonePermission() async {
    // Check if the permission is already granted
    if (await Permission.microphone.isGranted) {
      // The permission is granted, return true
      return true;
    }

    // Request the permission
    final status = await Permission.microphone.request();

    // Check if the permission is granted
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // The permission is denied, show an explanation or return false
      return false;
    } else if (status.isPermanentlyDenied) {
      // The permission is permanently denied, open app settings
      await openAppSettings();
      return false;
    }

    // For any other status, return false
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SingleChildScrollView(
            child: Column(),
          ),
          Expanded(
            flex: 4,
            child: RecognitionResultsWidget(
              hasSpeech: _hasSpeech,
              onTap: () {
                startListening().then((v) {
                  // speak(lastWords: v);
                });
              },
              lastWords: lastWords,
              level: level,
            ),
          ),
          // Expanded(
          //   child: ErrorWidget(lastError: lastError),
          // ),
          SpeechStatusWidget(speech: speech),
        ],
      ),
    );
  }

  Future<String> startListening() async {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);
    final options = SpeechListenOptions(
      onDevice: _onDevice,
      cancelOnError: true,
      autoPunctuation: true,
      enableHapticFeedback: true,
    );
    await speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: listenFor ?? 30),
      pauseFor: Duration(seconds: pauseFor ?? 7),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      listenOptions: options,
    );
    setState(() {});

    return lastWords;
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  Future<void> resultListener(SpeechRecognitionResult result) async {
    _logEvent(
      'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}',
    );

    lastWords = result.recognizedWords;
    resultData = result.finalResult;
    if (result.finalResult) {
      await speak(lastWords: lastWords);
      getResponse(lastError, lastWords);
    }
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
      'Received error status: ${error.errorMsg} - permanent: ${error.permanent}',
    );
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    _logEvent(
      'Received listener status: $status, listening: ${speech.isListening}',
    );
    setState(() {
      lastStatus = status;
    });
  }

  void _switchLang(String? selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal ?? _currentLocaleId;
    });
    debugPrint(selectedVal.toString());
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      final eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  void _switchLogging(bool? val) {
    setState(() {
      _logEvents = val ?? false;
    });
  }

  void _switchOnDevice(bool? val) {
    setState(() {
      _onDevice = val ?? false;
    });
  }
}

/// Displays the most recently recognized words and the sound level.
class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    required this.lastWords,
    required this.hasSpeech,
    required this.level,
    required this.onTap,
    super.key,
  });

  final String lastWords;
  final double level;
  final bool hasSpeech;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              ColoredBox(
                color: Theme.of(context).secondaryHeaderColor,
                child: Center(
                  child: Text(
                    lastWords,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: .26,
                          spreadRadius: level * 1.5,
                          color: Colors.black.withOpacity(.05),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: hasSpeech ? onTap : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Speech recognition available',
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}

/// Display the current error status from the speech
/// recognizer
class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    required this.lastError,
    super.key,
  });

  final String lastError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Center(
          child: Text(
            'Error Status',
            style: TextStyle(fontSize: 22),
          ),
        ),
        Center(
          child: SelectableText(lastError),
        ),
      ],
    );
  }
}

/// Controls to start and stop speech recognition
class SpeechControlWidget extends StatelessWidget {
  const SpeechControlWidget(
    this.hasSpeech,
    this.isListening,
    this.startListening,
    this.stopListening,
    this.cancelListening, {
    super.key,
  });

  final bool hasSpeech;
  final bool isListening;
  final void Function() startListening;
  final void Function() stopListening;
  final void Function() cancelListening;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: !hasSpeech || isListening ? null : startListening,
          child: const Text('Start'),
        ),
        TextButton(
          onPressed: isListening ? stopListening : null,
          child: const Text('Stop'),
        ),
        TextButton(
          onPressed: isListening ? cancelListening : null,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class SessionOptionsWidget extends StatelessWidget {
  const SessionOptionsWidget(
    this.currentLocaleId,
    this.switchLang,
    this.localeNames,
    this.logEvents,
    this.switchLogging,
    this.pauseForController,
    this.listenForController,
    this.onDevice,
    this.switchOnDevice, {
    super.key,
  });

  final String currentLocaleId;
  final void Function(String?) switchLang;
  final void Function(bool?) switchLogging;
  final void Function(bool?) switchOnDevice;
  final TextEditingController pauseForController;
  final TextEditingController listenForController;
  final List<LocaleName> localeNames;
  final bool logEvents;
  final bool onDevice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              const Text('Language: '),
              DropdownButton<String>(
                onChanged: (selectedVal) => switchLang(selectedVal),
                value: currentLocaleId,
                items: localeNames
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
          Row(
            children: [
              const Text('pauseFor: '),
              Container(
                padding: const EdgeInsets.only(left: 8),
                width: 80,
                child: TextFormField(
                  controller: pauseForController,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: const Text('listenFor: '),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8),
                width: 80,
                child: TextFormField(
                  controller: listenForController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('On device: '),
              Checkbox(
                value: onDevice,
                onChanged: switchOnDevice,
              ),
              const Text('Log events: '),
              Checkbox(
                value: logEvents,
                onChanged: switchLogging,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InitSpeechWidget extends StatelessWidget {
  const InitSpeechWidget(this.hasSpeech, this.initSpeechState, {super.key});

  final bool hasSpeech;
  final Future<void> Function() initSpeechState;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: hasSpeech ? null : initSpeechState,
          child: const Text('Initialize'),
        ),
      ],
    );
  }
}

/// Display the current status of the listener
class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    required this.speech,
    super.key,
  });

  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: speech.isListening
            ? const Text(
                "I'm listening...",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(
                'Not listening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
