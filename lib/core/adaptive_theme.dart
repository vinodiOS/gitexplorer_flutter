import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    primaryColor: const Color.fromRGBO(0, 198, 173, 1),
    textTheme: const TextTheme(
        bodyText1: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(74, 74, 74, 1),
            decoration: TextDecoration.none,
            letterSpacing: 1.5)),
    brightness: Brightness.light,
    backgroundColor: const Color.fromRGBO(238, 240, 242, 1));

final darkTheme = ThemeData(
    primaryColor: const Color.fromRGBO(0, 198, 173, 1),
    textTheme: const TextTheme(
        bodyText1: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
            decoration: TextDecoration.none,
            letterSpacing: 1.5)),
    brightness: Brightness.dark,
    backgroundColor: const Color.fromRGBO(31, 37, 45, 1));
