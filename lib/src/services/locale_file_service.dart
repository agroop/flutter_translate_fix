import 'dart:convert';

import 'package:flutter/services.dart';

class LocaleFileService {
  const LocaleFileService._();

  static Future<Map<String, String>> getLocaleFiles(
      List<String> locales, String basePath) async {
    final localizedFiles = await _getAllLocaleFiles(basePath);

    final files = <String, String>{};

    for (final language in locales.toSet()) {
      final file = _findLocaleFile(language, localizedFiles, basePath);

      files[language] = file;
    }

    return files;
  }

  static Future<String?> getLocaleContent(String file) async {
    try {
      final data = await rootBundle.load(file);
      final bytes = data.buffer.asUint8List();

      if (bytes.isEmpty) return null;

      return utf8.decode(bytes);
    } catch (_) {
      return null;
    }
  }

  static Future<List<String>> _getAllLocaleFiles(String basePath) async {
    try {
      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = assetManifest.listAssets();

      final separator = basePath.endsWith('/') ? '' : '/';

      return assets.where((x) => x.startsWith('$basePath$separator')).toList();
    } catch (_) {
      return [];
    }
  }

  static String _findLocaleFile(
      String languageCode, List<String> localizedFiles, String basePath) {
    final file = _getFilepath(languageCode, basePath);

    if (!localizedFiles.contains(file) && languageCode.contains('_')) {
      final baseFile = _getFilepath(languageCode.split('_').first, basePath);
      if (localizedFiles.contains(baseFile)) {
        return baseFile;
      }
    }

    return file;
  }

  static String _getFilepath(String languageCode, String basePath) {
    final separator = basePath.endsWith('/') ? '' : '/';
    return '$basePath$separator$languageCode.json';
  }
}
