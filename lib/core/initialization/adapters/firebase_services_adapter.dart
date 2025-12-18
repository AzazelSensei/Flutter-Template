import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/di/injection_container.dart' as di;
import 'package:flutter_template/core/firebase/analytics_service.dart';
import 'package:flutter_template/core/firebase/crashlytics_service.dart';
import 'package:flutter_template/core/initialization/app_initializer.dart';
import 'package:flutter_template/core/logging/logger_service.dart';

class FirebaseServicesAdapter implements InitializationAdapter {
  @override
  String get name => 'Firebase Services (Analytics, Crashlytics)';

  @override
  int get priority => 3;

  @override
  Future<void> initialize() async {
    await di.sl<AnalyticsService>().initialize();
    di.sl<LoggerService>().info('Firebase Analytics initialized');

    await di.sl<CrashlyticsService>().initialize();
    di.sl<LoggerService>().info('Firebase Crashlytics initialized');

    /*
     * Global Error Handlers
     * FlutterError: Widget build errors, assertion failures
     * PlatformDispatcher: Uncaught async errors
     */
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
