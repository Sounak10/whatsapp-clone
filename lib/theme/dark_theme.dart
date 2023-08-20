import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: Color(0xFFF87A44),
        floatingLabelStyle: TextStyle(color: Color(0xFFF87A44))),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white, selectionHandleColor: Color(0xFFF87A44)),
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
    ),
    colorScheme: ColorScheme.dark(
        background: Colors.black,
        primary: Colors.grey[900]!,
        secondary: Colors.grey[600]!,
        tertiary: Colors.grey[900]));
