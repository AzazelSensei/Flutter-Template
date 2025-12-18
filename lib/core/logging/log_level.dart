enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal;

  String get color {
    switch (this) {
      case LogLevel.debug:
        return '\x1B[37m'; 
      case LogLevel.info:
        return '\x1B[34m'; 
      case LogLevel.warning:
        return '\x1B[33m'; 
      case LogLevel.error:
        return '\x1B[31m'; 
      case LogLevel.fatal:
        return '\x1B[35m'; 
    }
  }

  String get emoji {
    switch (this) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.fatal:
        return '💀';
    }
  }

  String get displayName {
    switch (this) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.fatal:
        return 'FATAL';
    }
  }
}
