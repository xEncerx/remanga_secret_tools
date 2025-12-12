import 'package:backend/core/core.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:talker/talker.dart';

/// A middleware that catches errors during HTTP request processing
Middleware errorCatcherMiddleware() {
  return (handler) {
    return (context) async {
      try {
        return await handler(context);
      } catch (error, stackTrace) {
        getIt<Talker>().error(
          'HTTP Error: ${context.request.method} ${context.request.uri.path}',
          error,
          stackTrace,
        );

        return Response.json(
          statusCode: 500,
          body: {'error': 'Internal Server Error'},
        );
      }
    };
  };
}
