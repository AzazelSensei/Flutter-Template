import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/core/constants/app_constants.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage;

  TokenStorage(this._secureStorage);

  Future<void> saveToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
