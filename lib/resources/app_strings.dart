// ignore_for_file: constant_identifier_names

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AppStrings {
  static const String regexEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String strNoInternetConnection = 'No Internet Connection';
  static const String strConnectionTimeout = 'Connection Timeout';
  static const String strNoData = 'No Data';
  static const String strDot = '.';

  static const String dfIso8601String = 'yyyy-MM-ddTHH:mm:ss.mmmZ';
  static const String dfYMD = 'yyyy-MM-dd';

  static const String strAppName = 'VKJ App';

  static RxString appVersion = '0'.obs;

  static String strError = "Error";

  static var strSomethingWentWrong =
      "Something went wrong. Please try again later.";

  static String? strNetworkError = 'Network Error';

  static String recentlyPlayed = 'assets/images/recently_played.jpg';
  static String favorites = 'assets/images/favorites.jpg';
  static String mostPlayed = 'assets/images/most_played.jpg';
  static String recentlyAdded = 'assets/images/recently_added.jpg';
}
