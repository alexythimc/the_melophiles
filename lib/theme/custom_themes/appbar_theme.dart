import 'package:flutter/material.dart';

class TAppBarTheme {
  TAppBarTheme._(); // To avoid creating instances

  // -- Light Theme
  static final lightAppBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    //surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(size: 24, color: Colors.black),
    actionsIconTheme: const IconThemeData(size: 24, color: Colors.black),
  );

  // -- Dark Theme
  static final darkAppBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(size: 24, color: Colors.white),
    actionsIconTheme: const IconThemeData(size: 24, color: Colors.white),
  );
}
