import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextButtonTheme {
  // Customizable Text Button Theme with TextButtonThemeData for both light and dark themes
  static final light = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey,
      // side: const BorderSide(color: Colors.black),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: GoogleFonts.rajdhani().fontFamily,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
  static final dark = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      // backgroundColor: Colors.blue,
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey,
      // side: const BorderSide(color: Colors.blue),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontFamily: GoogleFonts.rajdhani().fontFamily,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  const TTextButtonTheme({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}
