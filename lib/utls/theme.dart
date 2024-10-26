import 'package:base_project/utls/colors.dart';
import 'package:flutter/material.dart';

TextTheme _textTheme = const TextTheme();

ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'OpenSans',
  textTheme: _textTheme,
  hoverColor: Colors.transparent,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  appBarTheme: AppBarTheme(backgroundColor: colorWhite),
  useMaterial3: false,
);
