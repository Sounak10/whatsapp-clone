import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: Color(0xFFF87A44),
        floatingLabelStyle: TextStyle(color: Color(0xFFF87A44))),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black, selectionHandleColor: Color(0xFFF87A44)),
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF87A44),
    ),
    colorScheme: ColorScheme.light(
        background: Colors.white,
        primary: Colors.white,
        secondary: Colors.grey[800]!,
        tertiary: Colors.grey[300]));
