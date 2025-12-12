import 'package:dart_frog/dart_frog.dart';
import 'package:sentry/sentry.dart';

/// A middleware that creates a Sentry transaction for each HTTP request.
Middleware sentryTransactionMiddleware() {
  return (handler) {
    return (context) async {
      final transaction = Sentry.startTransaction(
        '${context.request.method.value} ${context.request.uri.path}',
        'http.server',
        bindToScope: true,
      );

      try {
        final response = await handler(context);

        transaction.status = response.statusCode >= 500
            ? const SpanStatus.internalError()
            : response.statusCode >= 400
            ? const SpanStatus.invalidArgument()
            : const SpanStatus.ok();

        return response;
      } catch (error) {
        transaction
          ..status = const SpanStatus.internalError()
          ..throwable = error;
        rethrow;
      } finally {
        await transaction.finish();
      }
    };
  };
}
