import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeStorage {
  final FlutterSecureStorage _storage;

  ThemeStorage(this._storage);

  static const String _themeKey = 'selected_theme_id';
  Future<void> saveThemeId(String themeId) async {
    await _storage.write(key: _themeKey, value: themeId);
  }

  Future<String?> getThemeId() async {
    return await _storage.read(key: _themeKey);
  }

  Future<bool> hasTheme() async {
    final themeId = await getThemeId();
    return themeId != null && themeId.isNotEmpty;
  }

  Future<void> deleteTheme() async {
    await _storage.delete(key: _themeKey);
  }
}
