import 'package:backend/core/core.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shelf/shelf.dart' show HijackException;

/// Custom middleware which logs requests with additional information
Middleware requestLoggerMiddleware({
  void Function(String message)? log,
  String sourceHeader = 'x-client-source',
}) => (innerHandler) {
  final theLogger = log ?? _defaultLogger;

  return (context) {
    final request = context.request;

    // Start timing the request
    final startTime = DateTime.now().toUtc();
    final watch = Stopwatch()..start();

    // Get client IP address and source info
    final ip = _getRemoteIp(request);
    final source = request.headers[sourceHeader] ?? 'Unknown';

    return Future.sync(() => innerHandler(context)).then(
      (response) {
        final msg = HttpLogFormatter.formatMessage(
          RequestLogEntry(
            timestamp: startTime,
            duration: watch.elapsed,
            statusCode: response.statusCode,
            method: request.method.value,
            uri: request.uri,
            ip: ip,
            source: source,
          ),
        );

        theLogger(msg);

        return response;
      },
      onError: (Object error, StackTrace stackTrace) {
        if (error is HijackException) throw error;

        final msg = HttpLogFormatter.formatMessage(
          RequestLogEntry(
            timestamp: startTime,
            duration: watch.elapsed,
            statusCode: 500,
            method: request.method.value,
            uri: request.uri,
            ip: ip,
            source: source,
            error: error,
          ),
        );
        final st = HttpLogFormatter.formatStackTrace(stackTrace);

        theLogger('$msg\n$st');

        // ignore: only_throw_errors
        throw error;
      },
    );
  };
};

String _getRemoteIp(Request request) {
  final forwarded = request.headers['x-forwarded-for'];
  if (forwarded != null && forwarded.isNotEmpty) {
    return forwarded.split(',').first.trim();
  }

  return 'unknown-ip';
}

// ignore: avoid_print
void _defaultLogger(String msg) => print(msg);
