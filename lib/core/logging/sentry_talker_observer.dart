import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';

/// A Talker observer that sends errors and exceptions to Sentry.
class SentryTalkerObserver extends TalkerObserver {
  /// Creates a [SentryTalkerObserver] instance.
  SentryTalkerObserver({
    this.captureExceptions = true,
    this.captureErrors = true,
    this.captureLogs = true,
    this.captureLogLevels = const {LogLevel.critical, LogLevel.error},
  });

  /// Whether to capture exceptions.
  final bool captureExceptions;

  /// Whether to capture errors.
  final bool captureErrors;

  /// Whether to capture logs.
  final bool captureLogs;

  /// The minimum log level to capture.
  final Set<LogLevel> captureLogLevels;

  @override
  void onError(TalkerError err) {
    if (captureErrors) {
      Sentry.captureException(
        err.error,
        stackTrace: err.stackTrace,
        hint: Hint.withMap({
          'message': err.message,
          'time': err.time.toIso8601String(),
        }),
      );
    }
  }

  @override
  void onException(TalkerException err) {
    if (captureExceptions) {
      Sentry.captureException(
        err.exception,
        stackTrace: err.stackTrace,
        hint: Hint.withMap({
          'message': err.message,
          'time': err.time.toIso8601String(),
        }),
      );
    }
  }

  @override
  void onLog(TalkerData log) {
    if (!captureLogs) return;

    final logLevel = log.logLevel;
    if (logLevel == null) return;

    if (captureLogLevels.contains(logLevel)) {
      Sentry.captureException(
        log.message,
        stackTrace: log.stackTrace,
        hint: Hint.withMap({
          'message': log.message,
          'time': log.time.toIso8601String(),
        }),
      );
    }
  }
}
