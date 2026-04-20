import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF800020);
  static const String fontFamily = 'Poppins';

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
      ),
      useMaterial3: true,
      fontFamily: fontFamily,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w800),
        displayMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w700),
        displaySmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return Colors.grey;
        }),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          color: Colors.grey,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: fontFamily,
          color: primaryColor,
        ),
        prefixIconColor: primaryColor,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

