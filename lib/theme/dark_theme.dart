import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
    ),
    colorScheme: ColorScheme.dark(
        background: Colors.black,
        primary: Colors.grey[900]!,
        secondary: Colors.grey[600]!,
        tertiary: Colors.grey[900]));