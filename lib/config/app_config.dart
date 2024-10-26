import 'package:flutter/material.dart';

class AppConfig {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  GlobalKey bottomNavigationKey = GlobalKey();
  static bool isDebugMode = true;
}
