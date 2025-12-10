import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_limiter/shelf_limiter.dart';

/// Middleware for rate limiting API requests.
Handler rateLimitMiddleware(Handler handler) {
  final limiter = shelfLimiterByEndpoint(
    endpointLimits: {
      '/api/v1/packs/*': const RateLimiterOptions(
        maxRequests: 30,
        windowSize: Duration(minutes: 1),
      ),
    },
    defaultOptions: const RateLimiterOptions(
      maxRequests: 60,
      windowSize: Duration(minutes: 1),
    ),
  );

  return handler.use(fromShelfMiddleware(limiter));
}
