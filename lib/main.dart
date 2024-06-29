import 'package:base_project/features/splash_screen/view/splash_screen.dart';
import 'package:base_project/utls/routes.dart';
import 'package:base_project/utls/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appLightTheme,
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: onAppGenerateRoute(),
      routes: appRoutes(),
    );
  }
}

