import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleStorage {
  final FlutterSecureStorage _storage;
  static const String _localeKey = 'locale';

  LocaleStorage(this._storage);
  Future<void> saveLocale(String languageCode) async {
    await _storage.write(key: _localeKey, value: languageCode);
  }

  Future<String?> getLocale() async {
    return await _storage.read(key: _localeKey);
  }

  Future<void> clearLocale() async {
    await _storage.delete(key: _localeKey);
  }
}
