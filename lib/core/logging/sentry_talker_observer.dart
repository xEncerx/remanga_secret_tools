import 'package:sentry/sentry.dart';
import 'package:talker/talker.dart';

/// A Talker observer that sends errors and exceptions to Sentry.
class SentryTalkerObserver extends TalkerObserver {
  /// Creates a [SentryTalkerObserver] instance.
  SentryTalkerObserver(
    this._hub, {
    this.captureExceptions = true,
    this.captureErrors = true,
  });

  final Hub _hub;

  /// Whether to capture exceptions.
  final bool captureExceptions;

  /// Whether to capture errors.
  final bool captureErrors;

  @override
  void onError(TalkerError err) {
    if (captureErrors) {
      _hub.captureException(
        err.error,
        stackTrace: err.stackTrace,
        hint: Hint.withMap({
          'message': err.message,
          'time': err.time.toIso8601String(),
        }),
      );
    }

    super.onError(err);
  }

  @override
  void onException(TalkerException err) {
    if (captureExceptions) {
      _hub.captureException(
        err.exception,
        stackTrace: err.stackTrace,
        hint: Hint.withMap({
          'message': err.message,
          'time': err.time.toIso8601String(),
        }),
      );
    }

    super.onException(err);
  }
}
