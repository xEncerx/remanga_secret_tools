import 'package:backend/features/shared/cache/cache.dart';

/// Factory for creating cache service instances.
class CacheFactory {
  /// Creates an in-memory cache service.
  static CacheService createInMemory() {
    final cache = InMemoryCacheService()..startCleanup();
    return cache;
  }

  /// Creates a Redis cache service.
  static Future<CacheService> createRedis({
    required String host,
    required int port,
    String? password,
    int database = 0,
  }) async {
    final cache = RedisCacheService(
      host: host,
      port: port,
      password: password,
      database: database,
    );

    await cache.connect();
    return cache;
  }

  /// Creates a Redis cache service with an in-memory fallback.
  static Future<CacheService> createRedisWithFallback({
    required String host,
    required int port,
    String? password,
    int database = 0,
    void Function(Object error)? onFallback,
  }) async {
    try {
      return await createRedis(
        host: host,
        port: port,
        password: password,
        database: database,
      );
    } catch (e) {
      onFallback?.call(e);
      return createInMemory();
    }
  }
}
