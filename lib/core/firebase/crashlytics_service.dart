import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsService(this._crashlytics);
  Future<void> initialize() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
  }

  Future<void> logError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  Future<void> logException(
    Object exception,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    await logError(exception, stackTrace, reason: reason, fatal: false);
  }

  Future<void> logFatalError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    await logError(error, stackTrace, reason: reason, fatal: true);
  }

  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /*
   * Custom metadata ekleme - crash raporlarında debug için kullanılır
   * Firebase sadece primitive type'ları desteklediği için type checking yapıyoruz
   */
  Future<void> setCustomKey(String key, dynamic value) async {
    if (value is String) {
      await _crashlytics.setCustomKey(key, value);
    } else if (value is int) {
      await _crashlytics.setCustomKey(key, value);
    } else if (value is double) {
      await _crashlytics.setCustomKey(key, value);
    } else if (value is bool) {
      await _crashlytics.setCustomKey(key, value);
    } else {
      await _crashlytics.setCustomKey(key, value.toString());
    }
  }

  Future<void> clearUserIdentifier() async {
    await _crashlytics.setUserIdentifier('');
  }

  bool get isEnabled => true;
}
