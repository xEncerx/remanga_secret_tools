import 'package:stack_trace/stack_trace.dart';

/// A log entry representing an HTTP request.
class RequestLogEntry {
  /// Creates a new [RequestLogEntry].
  RequestLogEntry({
    required this.timestamp,
    required this.duration,
    required this.statusCode,
    required this.method,
    required this.uri,
    required this.ip,
    required this.source,
    this.error,
  });

  /// The timestamp when the request was made.
  final DateTime timestamp;

  /// The duration taken to process the request.
  final Duration duration;

  /// The HTTP status code of the response.
  final int statusCode;

  /// The HTTP method of the request.
  final String method;

  /// The requested URI.
  final Uri uri;

  /// The client's IP address.
  final String ip;

  /// The source of the request.
  final String source;

  /// The error object if an error occurred during request processing.
  final Object? error;

  /// Indicates whether the log entry represents an error.
  bool get isError => statusCode >= 500 || error != null;

  /// Indicates whether the log entry represents a warning.
  bool get isWarning => statusCode >= 400 && statusCode < 500;
}

/// A formatter for HTTP log entries.
class HttpLogFormatter {
  /// Formats a [RequestLogEntry] into a readable string.
  ///
  /// Format: DATE | LEVEL | METHOD PATH ➔ STATUS (DURATION) - \[IP\] {SRC}
  static String formatMessage(RequestLogEntry entry) {
    final dateStr = _formatData(entry.timestamp);
    final level = entry.isError
        ? 'ERROR'
        : (entry.isWarning ? 'WARNING' : 'INFO');

    // ignore: lines_longer_than_80_chars
    return '$dateStr | ${level.padRight(8)} | "${entry.method} ${entry.uri.path}${_formatQuery(entry.uri.query)}" '
        '➔  [${entry.statusCode}] (${_formatDuration(entry.duration)}) - '
        '[${entry.ip}] {${entry.source}}';
  }

  /// Formats the stack trace into a readable string.
  static String formatStackTrace(StackTrace stack) {
    return Chain.forTrace(stack)
        .foldFrames((frame) => frame.isCore || frame.package == 'shelf')
        .terse
        .toString();
  }

  static String _formatQuery(String query) => query.isEmpty ? '' : '?$query';

  /// Formats a [DateTime] into a human-readable string.
  static String _formatData(DateTime dt) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${twoDigits(dt.day)}-${twoDigits(dt.month)}-${dt.year} '
        '${twoDigits(dt.hour)}:${twoDigits(dt.minute)}:${twoDigits(dt.second)}';
  }

  /// Formats a [Duration] into a human-readable string.
  static String _formatDuration(Duration d) {
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds % 60}s';
    if (d.inSeconds > 0) {
      final ms = d.inMilliseconds % 1000;
      return '${d.inSeconds}.${(ms / 100).floor()}s';
    }
    return '${d.inMilliseconds}ms';
  }
}
