import 'package:flutter/material.dart';

/// A utility class that provides helper functions for various tasks.
/// This class contains static methods that can be used throughout the application.

class THelperFunctions {
  /// Checks if the given string is null or empty.
  static bool isNullOrEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  /// Checks if the given string is not null and not empty.
  static bool isNotNullOrEmpty(String? str) {
    return str != null && str.isNotEmpty;
  }

  /// Checks if the given string is a valid email address.

  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Checks if the given string is a valid phone number.
  static bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(
      r'^\+?[0-9]{10,15}$',
    );
    return phoneRegex.hasMatch(phoneNumber);
  }

  // return colors
  /// Returns a color from a string with all colors
  static Color getColorFromString(String colorString) {
    switch (colorString) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.transparent; // Default color if not found
    }
  }

  // return snackbar
  /// Shows a snackbar with the given message and duration.
  static void showSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// returns  a dialog with the given message and title.
  static void showDialogBox(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // trim string

  /// Trims the given string and returns it.
  static String trimString(String str) {
    return str.trim();
  }

  static getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
