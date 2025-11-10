import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_melophiles/theme/custom_themes/appbar_theme.dart';
import 'package:the_melophiles/theme/custom_themes/bottom_navigationbar_theme.dart';
import 'package:the_melophiles/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:the_melophiles/theme/custom_themes/checkbox_theme.dart';
import 'package:the_melophiles/theme/custom_themes/chip_theme.dart';
import 'package:the_melophiles/theme/custom_themes/elevatedButtonTheme.dart';
import 'package:the_melophiles/theme/custom_themes/outlined_button_theme.dart';
import 'package:the_melophiles/theme/custom_themes/text_form_field_theme.dart';
import 'package:the_melophiles/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._(); // Prevent instantiation

  /// 🌞 Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF2CBE49), // pink accent
      secondary: Colors.grey.shade800,
      surface: Colors.white,
    ),
    textTheme: TTextTheme.textTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    bottomNavigationBarTheme: TBottomNavigationBarTheme.lightTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightTextFormFieldTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    chipTheme: TChipTheme.lightChipTheme,
  );

  /// 🌙 Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF2CBE49),
      secondary: Colors.grey.shade300,
      surface: Colors.black,
    ),
    textTheme: TTextTheme.darkTextTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    bottomNavigationBarTheme: TBottomNavigationBarTheme.darkTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkTextFormFieldTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    chipTheme: TChipTheme.darkChipTheme,
  );
}
