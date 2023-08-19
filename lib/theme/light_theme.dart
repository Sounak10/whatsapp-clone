import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF87A44),
    ),
    colorScheme: ColorScheme.light(
        background: Colors.white,
        primary: Colors.white,
        secondary: Colors.grey[800]!,
        tertiary: Colors.grey[300]));
