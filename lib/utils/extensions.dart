import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

/// ==========================================================================
///                            COLOR EXTENSIONS
/// ==========================================================================
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

/// ==========================================================================
///                            TIMEOFDAY EXTENSIONS
/// ==========================================================================
extension CustomTime on TimeOfDay {
  String get formattedTime {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}

/// ==========================================================================
///                            NUMBER EXTENSIONS
/// ==========================================================================
extension CustomInt on int {
  double fixed({int fix = afterDot}) {
    return double.parse(toStringAsFixed(fix));
  }

  String get toMinutesSeconds {
    final minutes = (this ~/ 60).toString();
    final seconds = (this % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

extension CustomDouble on double {
  double fixed({int fix = afterDot}) {
    return double.parse(toStringAsFixed(fix));
  }
}

/// ==========================================================================
///                            STRING EXTENSIONS
/// ==========================================================================
extension CustomString on String {
  String? get nullIfEmpty {
    return isEmpty ? null : this;
  }

  double get parseToDouble {
    try {
      var value = replaceAll(" ", "");
      return double.parse(value.isEmpty ? "0" : value);
    } catch (e) {
      return 0.0;
    }
  }

  int get parseToInt {
    try {
      var value = replaceAll(" ", "");
      return int.parse(value.isEmpty ? "0" : value);
    } catch (e) {
      return 0;
    }
  }

  String get removeSpaces {
    return replaceAll(" ", '');
  }

  String phoneFormatter({String mask = "+000 (00) 000 00 00"}) {
    if (mask.isEmpty) {
      return this;
    }
    final chars = replaceAll(RegExp(r'\D+'), '').split('');

    // Agar mask length chars length bilan mos kelmasa, textni o'zini qaytarish
    if (chars.length != mask.replaceAll(RegExp(r'\D+'), '').length) {
      return this;
    }

    final result = <String>[];
    var index = 0;
    for (var i = 0; i < mask.length; i++) {
      if (index >= chars.length) {
        break;
      }
      final curChar = chars[index];
      if (mask[i] == '0') {
        /// If it's a digit in the mask, add the digit to the output
        if (_isDigit(curChar)) {
          result.add(curChar);
          index++;
        } else {
          break;
        }
      } else {
        /// Add the non-digit value from the mask to the output
        result.add(mask[i]);
      }
    }
    return result.join();
  }

  String get phoneReplace {
    return replaceAll(" ", "").replaceAll("(", "").replaceAll(")", "");
  }
}

/// ==========================================================================
///                         FORMATTED DATETIME (DATETIME, STRING)
/// ==========================================================================
extension FormattedDateTime on DateTime? {
  String get toApiDate {
    return this == null ? "" : DateFormat('yyyy-MM-dd').format(this!);
  }

  String get toApiTime {
    return this == null ? "" : DateFormat('HH:mm').format(this!);
  }

  String get toApiDateTime {
    return this == null ? "" : DateFormat('yyyy-MM-dd HH:mm').format(this!);
  }

  String get formattedDate {
    return this == null ? "" : DateFormat('dd.MM.yyyy').format(this!);
  }

  String get formattedTime {
    return this == null ? "" : DateFormat('HH:mm').format(this!);
  }

  String get formattedDateTime {
    return this == null ? "" : DateFormat('dd.MM.yyyy HH:mm').format(this!);
  }
}

extension FormattedDateTimeString on String {
  DateTime? get stringToDateTime {
    return DateTime.tryParse(this);
  }

  String get formattedDate {
    var date = DateTime.tryParse(this);
    return date != null ? DateFormat('dd.MM.yyyy').format(date) : this;
  }

  String get formattedDateTime {
    var date = DateTime.tryParse(this);
    return date != null ? DateFormat('dd.MM.yyyy HH:mm').format(date) : this;
  }

  String get formattedTime {
    var date = DateTime.tryParse(this);
    return date != null ? DateFormat('HH:mm').format(date) : this;
  }
}

/// ==========================================================================
///                     FORMATTED AMOUNT (INT, DOUBLE, STRING)
/// ==========================================================================
extension FormattedAmountInt on int? {
  String get formattedAmount {
    return _thousandDecimalFormat((this ?? 0).toDouble());
  }

  String get formattedAmountEmpty {
    String summa = _thousandDecimalFormat((this ?? 0).toDouble());
    return (summa == "0" || summa == "0.0") ? "" : summa;
  }
}

extension FormattedAmountString on String? {
  String get formattedAmount {
    return _thousandDecimalFormat((this ?? "").parseToDouble);
  }

  String get formattedAmountEmpty {
    String summa = _thousandDecimalFormat((this ?? "").parseToDouble);
    return (summa == "0" || summa == "0.0") ? "" : summa;
  }
}

extension FormattedAmountDouble on double? {
  String get formattedAmount {
    return _thousandDecimalFormat(this ?? 0.0);
  }

  String get formattedAmountEmpty {
    String summa = _thousandDecimalFormat(this ?? 0.0);
    return (summa == "0" || summa == "0.0") ? "" : summa;
  }
}

/// ==========================================================================
///                         SIZEDBOX EXTENSIONS
/// ==========================================================================
extension SizedBoxExtensions on num {
  SizedBox get height => SizedBox(height: toDouble());

  SizedBox get width => SizedBox(width: toDouble());

  SizedBox get box => SizedBox(width: toDouble(), height: toDouble());
}

/// ==========================================================================
///                        BUILD CONTEXT EXTENSIONS
/// ==========================================================================
extension BuildContextExtensions on BuildContext {
  EdgeInsets get _safePadding => MediaQuery.of(this).padding;

  double safeBottom([double height = 0.0]) => _safePadding.bottom + height;

  double safeTop([double height = 0.0]) => _safePadding.top + height;

  SizedBox safeBottomHeight([double height = 0.0]) => (safeBottom() + height).height;

  SizedBox safeTopHeight([double height = 0.0]) => (safeTop() + height).height;

  double get getScreenHeight => MediaQuery.of(this).size.height;

  double get getScreenWidth => MediaQuery.of(this).size.width;

// bool get isDarkModeEnabled => (AdaptiveTheme.maybeOf(this)?.mode == AdaptiveThemeMode.dark);
}

/// ==========================================================================
///                              HELPERS
/// ==========================================================================
String _thousandDecimalFormat(double value) {
  var num = value.toString();
  var numberDecimal = num.substring(num.indexOf('.') + 1);
  final numberInteger = List.from(num.substring(0, num.indexOf('.')).split(''));
  int index = numberInteger.length - 3;
  while (index > 0) {
    numberInteger.insert(index, ' ');
    index -= 3;
  }
  if (numberDecimal.length > afterDot) {
    numberDecimal = numberDecimal.substring(0, afterDot);
  }
  return int.parse(numberDecimal) > 0 ? "${numberInteger.join()}.$numberDecimal" : numberInteger.join();
}

bool _isDigit(String character) {
  if (character.isEmpty || character.length > 1) {
    return false;
  }
  return RegExp(r'[0-9]+').stringMatch(character) != null;
}
