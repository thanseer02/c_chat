import 'package:base_project/chat_screen/chat_screen.dart';
import 'package:base_project/features/home/home.dart';
import 'package:base_project/features/login_screen/view/login_screen.dart';
import 'package:base_project/features/splash_screen/view/splash_screen.dart';
import 'package:base_project/features/voice_read/voice_read_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> appRoutes() => {
      SplashScreen.routeName: (context) => const SplashScreen(),
      LoginScreen.routeName: (context) => const LoginScreen(),
      ChatScreen.routeName: (context) => const ChatScreen(),
      Voice.routeName: (context) => const Voice(),
      HomeScreen.routeName: (context) => const HomeScreen (),
    };
Widget? _getScreen(RouteSettings settings) {
  switch (settings.name) {
    default:
      return null;
  }
}

RouteFactory onAppGenerateRoute() => (settings) {
      final screen = _getScreen(settings);
      if (screen != null) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (_, a, __, c) {
            return FadeTransition(opacity: a, child: c);
          },
        );
      }
      return null;
    };
