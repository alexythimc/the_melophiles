import 'package:flutter/material.dart';

class TTextTheme {
  /// Customizable Light Text Theme
  static TextTheme textTheme = TextTheme(
    headlineLarge:
        const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
    headlineMedium:
        const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600),
    headlineSmall:
        const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600),
    titleLarge:
        const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
    titleMedium:
        const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500),
    titleSmall:
        const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyLarge:
        const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    bodyMedium:
        const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    bodySmall:
        const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    labelLarge: const TextStyle()
        .copyWith(fontSize: 12.0, fontWeight: FontWeight.normal),
    labelMedium: const TextStyle()
        .copyWith(fontSize: 12.0, fontWeight: FontWeight.normal),
  );

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge:
        const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
    headlineMedium:
        const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w800),
    headlineSmall:
        const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w800),
    titleLarge:
        const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w800),
    titleMedium:
        const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
    titleSmall:
        const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500),
    bodyLarge:
        const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w600),
    bodyMedium:
        const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w600),
    bodySmall:
        const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w600),
    labelLarge: const TextStyle()
        .copyWith(fontSize: 12.0, fontWeight: FontWeight.normal),
    labelMedium: const TextStyle()
        .copyWith(fontSize: 12.0, fontWeight: FontWeight.normal),
  );
}
