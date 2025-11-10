import 'package:intl/intl.dart';

/// Formats a given [number] to a currency string with the specified [locale].
/// The [currencySymbol] is used to prefix the formatted string.
/// The [decimalDigits] parameter specifies the number of decimal places to display.
/// The [locale] parameter specifies the locale to use for formatting.
/// The [currencySymbol] is optional and defaults to the currency symbol of the specified locale.
/// The [decimalDigits] parameter is optional and defaults to 2.
/// in a single class

class Formatter {
  static String formatCurrency(
    double number, {
    String? currencySymbol,
    int decimalDigits = 2,
    String locale = 'en_US',
  }) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol ??
          NumberFormat.simpleCurrency(locale: locale).currencySymbol,
      decimalDigits: decimalDigits,
    );
    return format.format(number);
  }

  //
  static String formatDate(
    DateTime date, {
    String format = 'yyyy-MM-dd',
  }) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }

  static String formatTime(
    DateTime time, {
    String format = 'HH:mm:ss',
  }) {
    final formatter = DateFormat(format);
    return formatter.format(time);
  }

  static String formatDateTime(
    DateTime dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) {
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  static String formatNumber(
    num number, {
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat('#,##0.${'0' * decimalDigits}');
    return formatter.format(number);
  }

  static String formatPhoneNumber(
    String phoneNumber, {
    String countryCode = '+1',
  }) {
    // Example formatting logic
    return '$countryCode $phoneNumber';
  }
// international phone number

  static String formatEmail(
    String email, {
    String domain = 'example.com',
  }) {
    // Example formatting logic
    return '$email@$domain';
  }

  static String formatPostalCode(
    String postalCode, {
    String countryCode = 'US',
  }) {
    // Example formatting logic
    return '$postalCode $countryCode';
  }

  static String formatAddress(
    String address, {
    String city = '',
    String state = '',
    String postalCode = '',
  }) {
    // Example formatting logic
    return '$address, $city, $state, $postalCode';
  }

  static String formatUrl(
    String url, {
    String scheme = 'https',
  }) {
    // Example formatting logic
    return '$scheme://$url';
  }

  static String formatCreditCard(
    String cardNumber, {
    String cardType = 'Visa',
  }) {
    // Example formatting logic
    return '$cardType: $cardNumber';
  }

  static String formatSocialSecurityNumber(
    String ssn, {
    String countryCode = 'US',
  }) {
    // Example formatting logic
    return '$countryCode $ssn';
  }

  static String formatLicensePlate(
    String plateNumber, {
    String state = '',
  }) {
    // Example formatting logic
    return '$plateNumber $state';
  }
}
