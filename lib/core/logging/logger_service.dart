import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/logging/log_level.dart';

class LoggerService {
  static const int _maxLineLength = 120;
  static const int _maxResponseLength = 300; 
  final bool enabled;
  final LogLevel minLevel;
  final bool verboseResponses;
  dynamic _crashlyticsService;

  LoggerService({
    bool? enabled,
    LogLevel? minLevel,
    this.verboseResponses = false, 
  })  : enabled = enabled ?? kDebugMode,
        minLevel = minLevel ?? (kDebugMode ? LogLevel.debug : LogLevel.error);
  void setCrashlyticsService(dynamic crashlyticsService) {
    _crashlyticsService = crashlyticsService;
  }

  void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      level: LogLevel.debug,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void info(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      level: LogLevel.info,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      level: LogLevel.warning,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      level: LogLevel.error,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    /*
     * Error seviyesinde otomatik Crashlytics entegrasyonu
     * Production'da hataları track edebilmek için kritik
     */
    if (error != null && stackTrace != null && _crashlyticsService != null) {
      try {
        _crashlyticsService.logException(error, stackTrace, reason: message);
      } catch (_) {}
    }
  }

  void fatal(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      level: LogLevel.fatal,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    if (error != null && stackTrace != null && _crashlyticsService != null) {
      try {
        _crashlyticsService.logFatalError(error, stackTrace, reason: message);
      } catch (_) {}
    }
  }

  void logRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
  }) {
    if (!_shouldLog(LogLevel.debug)) return;

    final buffer = StringBuffer();
    buffer.writeln(
      '┌────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ 🌐 HTTP REQUEST');
    buffer.writeln(
      '├────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ Method: $method');
    buffer.writeln('│ URL: $url');

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('│ Headers:');
      headers.forEach((key, value) {
        buffer.writeln('│   $key: $value');
      });
    }

    if (data != null) {
      final dataStr = data.toString();
      if (verboseResponses || dataStr.length <= _maxResponseLength) {
        buffer.writeln('│ Body: $dataStr');
      } else {
        final truncated = dataStr.substring(0, _maxResponseLength);
        buffer.writeln('│ Body: $truncated...');
        buffer.writeln('│ 📝 Body truncated (${dataStr.length} chars total)');
      }
    }

    buffer.writeln(
      '└────────────────────────────────────────────────────────────',
    );

    _print(buffer.toString());
  }

  void logResponse({
    required int statusCode,
    required String url,
    dynamic data,
    Duration? duration,
  }) {
    if (!_shouldLog(LogLevel.debug)) return;

    final isSuccess = statusCode >= 200 && statusCode < 300;
    final emoji = isSuccess ? '✅' : '❌';

    final buffer = StringBuffer();
    buffer.writeln(
      '┌────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ $emoji HTTP RESPONSE');
    buffer.writeln(
      '├────────────────────────────────────────────────────────────',
    );
    buffer.writeln('│ Status: $statusCode');
    buffer.writeln('│ URL: $url');

    if (duration != null) {
      buffer.writeln('│ Duration: ${duration.inMilliseconds}ms');
    }

    if (data != null) {
      final responseStr = data.toString();
      if (verboseResponses || responseStr.length <= _maxResponseLength) {
        buffer.writeln('│ Response: $responseStr');
      } else {
        final truncated = responseStr.substring(0, _maxResponseLength);
        buffer.writeln('│ Response: $truncated...');
        buffer.writeln('│ 📝 Response truncated (${responseStr.length} chars total)');
        buffer.writeln('│ 💡 Set verboseResponses: true to see full response');
      }
    }

    buffer.writeln(
      '└────────────────────────────────────────────────────────────',
    );

    _print(buffer.toString());
  }

  void logNetworkError({
    required String url,
    required Object error,
    StackTrace? stackTrace,
  }) {
    _log(
      level: LogLevel.error,
      message: 'Network request failed: $url',
      tag: 'NETWORK',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _log({
    required LogLevel level,
    required String message,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog(level)) return;

    final tagText = tag != null ? '[$tag] ' : '';
    final levelText = level.displayName.toUpperCase().padRight(7);
    final buffer = StringBuffer();
    buffer.write('$levelText │ $tagText$message');
    if (error != null) {
      buffer.write('\n  ↳ Error: $error');
    }
    if (stackTrace != null && level.index >= LogLevel.error.index) {
      buffer.write('\n  ↳ Stack trace:\n');
      buffer.write(_formatStackTrace(stackTrace));
    }

    _print(buffer.toString());

    // developer.log(
    //   message,
    //   time: DateTime.now(),
    //   level: _getDeveloperLogLevel(level),
    //   name: tag ?? 'Shartflix',
    //   error: error,
    //   stackTrace: stackTrace,
    // );
  }

  bool _shouldLog(LogLevel level) {
    return enabled && level.index >= minLevel.index;
  }

  void _print(String message) {
    final lines = message.split('\n');
    for (final line in lines) {
      if (line.length <= _maxLineLength) {
        debugPrint(line);
      } else {
        for (int i = 0; i < line.length; i += _maxLineLength) {
          final end = (i + _maxLineLength < line.length)
              ? i + _maxLineLength
              : line.length;
          debugPrint(line.substring(i, end));
        }
      }
    }
  }

  /*
   * Stack trace'i 5 satırla limitlendiriyoruz
   * Console'un kalabalık olmaması ve performans için
   */
  String _formatStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');
    final buffer = StringBuffer();
    final maxLines = lines.length > 5 ? 5 : lines.length;
    for (int i = 0; i < maxLines; i++) {
      buffer.writeln('    ${lines[i]}');
    }

    if (lines.length > 5) {
      buffer.writeln('    ... (${lines.length - 5} more lines)');
    }

    return buffer.toString();
  }

  // int _getDeveloperLogLevel(LogLevel level) {
  //   switch (level) {
  //     case LogLevel.debug:
  //       return 500;
  //     case LogLevel.info:
  //       return 800;
  //     case LogLevel.warning:
  //       return 900;
  //     case LogLevel.error:
  //       return 1000;
  //     case LogLevel.fatal:
  //       return 1200;
  //   }
  // }
}
