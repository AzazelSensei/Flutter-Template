/*
 * App Initialization System
 *
 * [Adapter Pattern] kullanılarak tasarlanmış modüler ve test edilebilir başlatma sistemi.
 * Her bir başlatma adımı (Firebase, DI, Cache vb.) bir [InitializationAdapter]
 * olarak implemente edilir.
 *
 * Özellikler:
 * - Öncelik (Priority) tabanlı sıralı çalışma.
 * - Hata toleransı (Bir adım patlarsa diğerleri çalışmaya devam eder).
 * - Performans takibi (Her adımın kaç ms sürdüğü loglanır).
 *
 * Kullanım:
 * ```dart
 * final logger = LoggerService();
 * AppInitializer.setLogger(logger);
 * registerInitializationAdapters();
 * await AppInitializer.initialize();
 * ```
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/logging/logger_service.dart';

abstract class InitializationAdapter {
  String get name;

  int get priority;

  Future<void> initialize();
}

class AppInitializer {
  AppInitializer._();

  static final List<InitializationAdapter> _adapters = [];
  static bool _isInitialized = false;
  static LoggerService? _logger;

  static void setLogger(LoggerService logger) {
    _logger = logger;
  }

  static void register(InitializationAdapter adapter) {
    if (_isInitialized) {
      throw StateError('Cannot register adapters after initialization');
    }
    _adapters.add(adapter);
  }

  static Future<void> initialize() async {
    if (_isInitialized) {
      _log('AppInitializer zaten başlatıldı, atlanıyor...');
      return;
    }

    _adapters.sort((a, b) => a.priority.compareTo(b.priority));

    _log('Uygulama başlatılıyor (${_adapters.length} adapter)...');

    for (final adapter in _adapters) {
      try {
        _log('[${adapter.priority}] ${adapter.name} başlatılıyor...');
        final stopwatch = Stopwatch()..start();

        await adapter.initialize();

        stopwatch.stop();
        _log(
          '[${adapter.priority}] ${adapter.name} tamamlandı (${stopwatch.elapsedMilliseconds}ms)',
        );
      } catch (e, stackTrace) {
        _logError(
          '[${adapter.priority}] ${adapter.name} başarısız',
          error: e,
          stackTrace: stackTrace,
        );

        /*
         * NOT: Bir adapter fail olsa bile diğer adapter'lar çalışmaya devam eder.
         * Bu sayede kritik olmayan servislerin hataları uygulamanın açılmasını engellemez.
         */
      }
    }

    _isInitialized = true;
    _log('Uygulama başlatma tamamlandı.');
  }

  static void _log(String message) {
    if (_logger != null) {
      _logger!.info(message, tag: 'AppInitializer');
    } else {
      debugPrint('▶ $message');
    }
  }

  static void _logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_logger != null) {
      _logger!.error(
        message,
        tag: 'AppInitializer',
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      debugPrint('✗ $message: $error');
      if (kDebugMode && stackTrace != null)
        debugPrintStack(stackTrace: stackTrace);
    }
  }

  @visibleForTesting
  static void reset() {
    _adapters.clear();
    _isInitialized = false;
  }
}
