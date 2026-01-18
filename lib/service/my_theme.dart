import 'package:flutter/material.dart';

class MyThemes {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // في 2026، استخدام ColorScheme.fromSeed هو الأفضل لتوليد ألوان متناسقة
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black, // اللون الأساسي للتطبيق
      brightness: Brightness.light,
      // surface: Colors.white, // لون الأسطح (الكروت، القوائم)
      surface: Colors.white,
    ),
    // تغيير الخلفية لرمادي فاتح جداً لإبراز الكروت البيضاء
    scaffoldBackgroundColor: const Color(0xFFF3F3F3),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      // foregroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    // تحسين شكل الأزرار لعام 2026
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.dark,
      surface: const Color.fromARGB(255, 34, 34, 34), // لون سطح داكن مريح للعين
    ),
    scaffoldBackgroundColor: const Color.fromARGB(
      255,
      17,
      17,
      17,
    ), // خلفية داكنة OLED

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: const Color.fromARGB(255, 34, 34, 34),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
