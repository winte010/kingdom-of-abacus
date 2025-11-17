enum LogLevel { debug, info, warning, error }

class Logger {
  static LogLevel currentLevel = LogLevel.info;

  static void debug(String message) {
    if (currentLevel.index <= LogLevel.debug.index) {
      print('[DEBUG] $message');
    }
  }

  static void info(String message) {
    if (currentLevel.index <= LogLevel.info.index) {
      print('[INFO] $message');
    }
  }

  static void warning(String message) {
    if (currentLevel.index <= LogLevel.warning.index) {
      print('[WARNING] $message');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (currentLevel.index <= LogLevel.error.index) {
      print('[ERROR] $message');
      if (error != null) print('  Error: $error');
      if (stackTrace != null) print('  Stack trace:\n$stackTrace');
    }
  }
}
