import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelper {
  static void showLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    } else if (kReleaseMode) {
      //print(message);
    }
  }

  static String dateTimeToString(
    DateTime? dateTime, {
    String format = 'MMM d, yyyy',
  }) {
    if (dateTime == null) return "";
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(dateTime);
  }

  static String formatDate(String rawDate, {String format = 'MMM d, yyyy'}) {
    final DateTime parsedDate = DateTime.parse(rawDate);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(parsedDate);
  }

  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (Platform.isIOS) {
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Map<String, String> parseValueAndUnit(String input) {
    input = input.trim();

    // Split based on the last space character
    final lastSpace = input.lastIndexOf(' ');
    if (lastSpace == -1) {
      return {'value': input, 'unit': ''};
    }

    final value = input.substring(0, lastSpace).trim();
    final unit = input.substring(lastSpace + 1).trim();

    return {'value': value, 'unit': unit};
  }

  // get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // get screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // dark mode check
  static bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  // is landscape mode
  static bool isLandscapeMode(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  static getAppBarHeight(BuildContext context) {
    return AppBar().preferredSize.height + 25;
  }

  static Future getDeviceID() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID on Android
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID on iOS
    }
  }

  // is tablet check
  static bool isTablet(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }
}
