import 'package:backend/features/features.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// TODO: change CORS settings before production deployment

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        fromShelfMiddleware(
          corsHeaders(
            headers: {
              ACCESS_CONTROL_ALLOW_ORIGIN: '*',
              ACCESS_CONTROL_ALLOW_HEADERS: 'Content-Type, Authorization',
              ACCESS_CONTROL_ALLOW_METHODS: 'GET, POST, PUT, DELETE, OPTIONS',
            },
            // headers: {
            //   shelf.ACCESS_CONTROL_ALLOW_ORIGIN: 'https://oreshka.me',
            //   shelf.ACCESS_CONTROL_ALLOW_METHODS: 'GET, POST, PUT, DELETE',
            //   shelf.ACCESS_CONTROL_ALLOW_HEADERS: 'Content-Type, Authorization',
            //   shelf.ACCESS_CONTROL_ALLOW_CREDENTIALS: 'true',
            // },
          ),
        ),
      )
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
