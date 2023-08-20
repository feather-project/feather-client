class LogModel {
  final int timestamp;
  final String message;
  final String level;

  LogModel(this.timestamp, this.message, this.level);
}

class LogLevel {
  static final error = LogLevel._internal('Error');
  static final warn = LogLevel._internal('Warn');
  static final info = LogLevel._internal('Info');
  static final debug = LogLevel._internal('Debug');

  final String name;

  LogLevel._internal(this.name);

  String getName() {
    return name;
  }

  static LogLevel fromInput(String input) {
    switch (input.toLowerCase()) {
      case 'error':
        return LogLevel.error;
      case 'warn':
        return LogLevel.warn;
      case 'info':
        return LogLevel.info;
      case 'debug':
        return LogLevel.debug;
      default:
        return LogLevel._internal(input);
    }
  }
}
