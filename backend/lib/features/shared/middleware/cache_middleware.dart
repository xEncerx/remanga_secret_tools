import 'dart:convert';

import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware configuration for caching.
class CacheConfig {
  /// Creates a [CacheConfig] instance.
  const CacheConfig({
    required this.duration,
    this.keyPrefix,
    this.cacheOnlySuccessful = true,
  });

  /// The duration for which the cache is valid.
  final Duration duration;

  /// An optional prefix for cache keys.
  final String? keyPrefix;

  /// Whether to cache only successful responses.
  final bool cacheOnlySuccessful;
}

/// A middleware that adds caching capabilities to handlers.
Middleware cacheMiddlewareByEndpoint({
  required Map<String, CacheConfig> endpointConfigs,
  CacheConfig? defaultConfig,
}) {
  return (Handler handler) {
    return (RequestContext context) async {
      final cacheService = getIt<CacheService>();
      final request = context.request;

      // Cancel caching for non-GET requests
      if (request.method != HttpMethod.get) {
        return handler(context);
      }

      final path = request.uri.path;
      final config = _findMatchingConfig(path, endpointConfigs, defaultConfig);

      if (config == null) {
        return handler(context);
      }

      final cacheKey = _generateCacheKey(request, config.keyPrefix);
      final cachedResponse = await cacheService.get(cacheKey);

      if (cachedResponse != null) {
        try {
          final cachedData = jsonDecode(cachedResponse) as Map<String, dynamic>;
          return Response(
            statusCode: cachedData['statusCode'] as int,
            body: cachedData['body'] as String,
            headers: Map<String, String>.from(
              cachedData['headers'] as Map? ?? {},
            )..addAll({'X-Cache': 'HIT'}),
          );
        } catch (e) {
          await cacheService.delete(cacheKey);
        }
      }

      final response = await handler(context);

      final shouldCache =
          !config.cacheOnlySuccessful ||
          (response.statusCode >= 200 && response.statusCode < 300);

      if (shouldCache) {
        final body = await response.body();
        final cacheData = jsonEncode({
          'statusCode': response.statusCode,
          'body': body,
          'headers': response.headers,
        });

        await cacheService.set(
          cacheKey,
          cacheData,
          ttl: config.duration,
        );

        return Response(
          statusCode: response.statusCode,
          body: body,
          headers: Map<String, String>.from(response.headers)
            ..addAll({'X-Cache': 'MISS'}),
        );
      }

      return response;
    };
  };
}

// === Helper Functions ===

/// Generates a cache key based on the request and an optional prefix.
String _generateCacheKey(Request request, String? prefix) {
  final uri = request.uri;
  final path = uri.path;
  final query = uri.query.isEmpty ? '' : '?${uri.query}';
  final baseKey = '$path$query';

  return prefix != null ? '$prefix:$baseKey' : baseKey;
}

/// Finds the matching [CacheConfig] for a given path.
CacheConfig? _findMatchingConfig(
  String path,
  Map<String, CacheConfig> endpointConfigs,
  CacheConfig? defaultConfig,
) {
  if (endpointConfigs.containsKey(path)) {
    return endpointConfigs[path];
  }

  for (final entry in endpointConfigs.entries) {
    if (_matchesPattern(path, entry.key)) {
      return entry.value;
    }
  }

  return defaultConfig;
}

/// Checks if a given path matches a pattern with wildcards.
bool _matchesPattern(String path, String pattern) {
  if (pattern.endsWith('/*')) {
    final prefix = pattern.substring(0, pattern.length - 2);
    return path.startsWith(prefix);
  }

  if (pattern.endsWith('*')) {
    final prefix = pattern.substring(0, pattern.length - 1);
    return path.startsWith(prefix);
  }

  return path == pattern;
}
