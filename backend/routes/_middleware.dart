import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Handler middleware(Handler handler) {
  return handler
      .use(
        fromShelfMiddleware(
          corsHeaders(
            headers: {
              ACCESS_CONTROL_ALLOW_ORIGIN: EnvConfig.allowedOrigin,
              ACCESS_CONTROL_ALLOW_HEADERS: 'Content-Type, Authorization',
              ACCESS_CONTROL_ALLOW_METHODS: 'GET, POST, PUT, DELETE, OPTIONS',
            },
          ),
        ),
      )
      .use(sentryTransactionMiddleware())
      .use(errorCatcherMiddleware())
      .use(requestLogger())
      .use(
        cacheMiddlewareByEndpoint(
          endpointConfigs: {
            '/api/v1/packs/*': const CacheConfig(
              duration: Duration(seconds: 40),
              keyPrefix: 'packs_endpoint',
            ),
          },
        ),
      )
      .use(rateLimitMiddleware);
}
