import 'package:flutter/material.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._(); // To avoid creating instances

  // -- Light Theme
  static final lightTextFormFieldTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    hintStyle: const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    errorStyle: const TextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
    floatingLabelStyle: const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    filled: true,
    fillColor: Colors.white,
    // -- Border: enabled, focused, error,focused error,
    // -- disabled, error, focused error
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.black12,
        width: 1,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),

    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.orange,
        width: 2,
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
  );

  // -- Dark Theme
  static final darkTextFormFieldTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
    hintStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
    errorStyle: const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
    floatingLabelStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
    filled: true,
    fillColor: Colors.black,
    // -- Border: enabled, focused, error,focused error,
    // -- disabled, error, focused error
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.white12,
        width: 1,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),

    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.orange,
        width: 2,
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
  );
}
