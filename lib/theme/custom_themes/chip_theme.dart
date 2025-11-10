import 'package:flutter/material.dart';

class TChipTheme {
  TChipTheme._(); // To avoid creating instances

  // -- Light Theme
  static final lightChipTheme = ChipThemeData(
    backgroundColor: Colors.white,
    selectedColor: Colors.blue,
    secondarySelectedColor: Colors.blueAccent,
    disabledColor: Colors.grey,
    selectedShadowColor: Colors.blue.withOpacity(0.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // -- Dark Theme
  static final darkChipTheme = ChipThemeData(
    backgroundColor: Colors.black,
    selectedColor: Colors.blue,
    secondarySelectedColor: Colors.blueAccent,
    disabledColor: Colors.grey,
    selectedShadowColor: Colors.blue.withOpacity(0.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
