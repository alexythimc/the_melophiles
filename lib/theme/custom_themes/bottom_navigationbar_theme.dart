import 'package:flutter/material.dart';

class TBottomNavigationBarTheme {
  static final BottomNavigationBarThemeData lightTheme =
      BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    showSelectedLabels: true,
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  );
  static final BottomNavigationBarThemeData darkTheme =
      BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 0, 0, 0),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    showSelectedLabels: true,
    selectedIconTheme: IconThemeData(
      fill: 1,
    ),
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  );
}
