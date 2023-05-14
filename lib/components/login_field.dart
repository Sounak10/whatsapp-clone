import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const LoginField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFF87A44)),
              borderRadius: BorderRadius.circular(12)),
          hintText: hintText),
    );
  }
}
