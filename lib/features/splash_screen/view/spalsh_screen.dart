import 'package:flutter/material.dart';

class SpashScreen extends StatefulWidget {
  const SpashScreen({super.key});
  static const routname = '/slashscreen';

  @override
  State<SpashScreen> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
