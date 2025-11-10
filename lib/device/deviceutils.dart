// device_utils.dart
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TDeviceUtils {
  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // get mode
  static bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get orientation
  static Orientation orientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Hide status and navigation bars
  static void hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  /// Show status and navigation bars
  static void showSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Lock portrait mode
  static void lockPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Unlock all orientations
  static void unlockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Check if platform is Android
  static bool isAndroid() => Platform.isAndroid;

  /// Check if platform is iOS
  static bool isIOS() => Platform.isIOS;

  /// Check internet connectivity
  static Future<bool> isConnected() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Launch URL in browser
  static Future<void> launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Trigger haptic feedback
  static void vibrate() {
    HapticFeedback.vibrate();
  }

  /// Get device info
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return {
        'platform': 'Android',
        'model': info.model,
        'version': info.version.release,
        'brand': info.brand,
        'isPhysicalDevice': info.isPhysicalDevice,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      return {
        'platform': 'iOS',
        'model': info.utsname.machine,
        'version': info.systemVersion,
        'name': info.name,
        'isPhysicalDevice': info.isPhysicalDevice,
      };
    } else {
      return {'error': 'Unsupported platform'};
    }
  }

  /// Get app version info
  static Future<Map<String, String>> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return {
      'appName': info.appName,
      'packageName': info.packageName,
      'version': info.version,
      'buildNumber': info.buildNumber,
    };
  }

  static Size getAppBarSize() {
    return const Size.fromHeight(kToolbarHeight);
  }

  static Size getTabBarSize() {
    return const Size.fromHeight(kToolbarHeight + (kTextTabBarHeight - 30));
  }

  static double getBottomNavigationBarSize() {
    // return double height of the bottom navigation bar
    return const Size.fromHeight(kBottomNavigationBarHeight) as double;
  }
}
