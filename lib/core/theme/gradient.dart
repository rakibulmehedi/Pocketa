import 'package:flutter/material.dart';

class CardGradients {
  static const LinearGradient softBlueGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 30, 136, 229),
      Color.fromARGB(255, 210, 210, 215),
    ],
  );

  static const LinearGradient subtleWash = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7F9FC), Color(0xFFFFFFFF)],
  );
}
