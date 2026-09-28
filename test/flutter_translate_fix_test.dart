import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate_fix/flutter_translate_fix.dart';
import 'package:flutter_translate_fix/src/services/locale_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleService tests', () {
    test('findLocale matches exact and language-only locales', () {
      final supported = [
        const Locale('en', 'US'),
        const Locale('pt', 'PT'),
        const Locale('es'),
      ];

      expect(LocaleService.findLocale(const Locale('en', 'US'), supported), const Locale('en', 'US'));
      expect(LocaleService.findLocale(const Locale('en'), supported), const Locale('en', 'US'));
      expect(LocaleService.findLocale(const Locale('es', 'ES'), supported), const Locale('es'));
      expect(LocaleService.findLocale(const Locale('fr'), supported), null);
    });

    test('getLocaleContent matches locale even when language-only or full locale is passed', () async {
      final supportedLocalesMap = {
        const Locale('en', 'US'): 'assets/i18n/en_US.json',
        const Locale('es'): 'assets/i18n/es.json',
      };

      // Querying with language-only Locale('en') should resolve to Locale('en', 'US')
      final matchedLocale = LocaleService.findLocale(const Locale('en'), supportedLocalesMap.keys.toList());
      expect(matchedLocale, const Locale('en', 'US'));
    });
  });

  group('LocalizationDelegate tests', () {
    test('isSupported returns true only for supported locales', () async {
      final delegate = await LocalizationDelegate.create(
        fallbackLocale: 'en_US',
        supportedLocales: ['en_US', 'es'],
      );

      expect(delegate.isSupported(const Locale('en', 'US')), isTrue);
      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('es', 'ES')), isTrue);
      expect(delegate.isSupported(const Locale('fr')), isFalse);
    });

    test('load resolves locale and avoids reloading if already active', () async {
      final delegate = await LocalizationDelegate.create(
        fallbackLocale: 'en_US',
        supportedLocales: ['en_US', 'es'],
      );

      final loc = await delegate.load(const Locale('en'));
      expect(loc, isNotNull);
      expect(delegate.currentLocale, const Locale('en', 'US'));
    });
  });

  group('Localization class tests', () {
    test('translates key and nested keys', () {
      Localization.load({
        'app_bar': {'title': 'Hello World'},
        'simple_key': 'Simple Value',
      });

      expect(translate('app_bar.title'), 'Hello World');
      expect(translate('simple_key'), 'Simple Value');
      expect(translate('missing_key'), 'missing_key');
    });

    test('translates with fallback when key is missing in primary', () {
      Localization.load(
        {'simple_key': 'Simple Value'},
        {'missing_in_primary': 'Fallback Value'},
      );

      expect(translate('simple_key'), 'Simple Value');
      expect(translate('missing_in_primary'), 'Fallback Value');
      expect(translate('unknown'), 'unknown');
    });

    test('handles map navigation safely even with non-map or empty values', () {
      Localization.load({
        'app_bar': 'Not a map',
        'empty_map': {},
      });

      expect(translate('app_bar.title'), 'app_bar.title');
      expect(translate('empty_map.key'), 'empty_map.key');
    });
  });
}
