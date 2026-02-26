import 'dart:io';

import 'package:flutter/widgets.dart';

/// Returns the current device locale
Locale getCurrentLocale() => _localeFromString(Platform.localeName);

Locale _localeFromString(String code) {
  final separator = code.contains('_')
      ? '_'
      : code.contains('-')
          ? '-'
          : null;

  if (separator == null) return Locale(code);

  final parts = code.split(RegExp(separator));
  return Locale(parts.first, parts.last);
}
