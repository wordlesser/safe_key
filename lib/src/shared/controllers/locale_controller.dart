import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleController extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _kLocale = 'sk_locale';

  Locale? _locale;

  Locale? get locale => _locale;

  LocaleController() {
    _load();
  }

  Future<void> _load() async {
    final stored = await _storage.read(key: _kLocale);
    if (stored != null) {
      final parts = stored.split('_');
      _locale = parts.length == 2
          ? Locale(parts[0], parts[1])
          : Locale(parts[0]);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    if (locale == null) {
      await _storage.delete(key: _kLocale);
    } else {
      final value = locale.countryCode != null
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      await _storage.write(key: _kLocale, value: value);
    }
    notifyListeners();
  }
}
