import 'package:flutter/material.dart';

class MyThemes {
  static final light = ThemeData(
    useMaterial3: true, // Material 3 is the 2025 standard
    brightness: Brightness.light,
    colorSchemeSeed: Colors.white, // Dynamically generates harmonious colors
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    cardTheme: CardThemeData(color: Colors.white, elevation: 0),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.white,
    scaffoldBackgroundColor: const Color.fromARGB(255, 43, 43, 43),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      elevation: 0,
    ),
    cardTheme: CardThemeData(color: Colors.white12, elevation: 0),
  );
}
