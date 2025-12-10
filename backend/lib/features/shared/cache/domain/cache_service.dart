import 'package:meta/meta.dart';

/// Abstract interface for cache service
abstract class CacheService {
  /// Get value by key
  Future<String?> get(String key);

  /// Set value with optional TTL
  Future<void> set(String key, String value, {Duration? ttl});

  /// Delete value by key
  Future<void> delete(String key);

  /// Check if key exists
  Future<bool> exists(String key);

  /// Clear entire cache
  Future<void> clear();

  /// Close connection (for Redis)
  Future<void> dispose();
}

/// Model for storing cached data with time-to-live
@immutable
class CacheEntry {
  /// Creates a [CacheEntry] instance.
  const CacheEntry({
    required this.value,
    required this.expiresAt,
  });

  /// The cached value.
  final String value;

  /// The expiration time of the cached value.
  final DateTime? expiresAt;

  /// Checks if the cache entry has expired.
  bool get isExpired {
    if (expiresAt == null) return false;

    return DateTime.now().isAfter(expiresAt!);
  }
}
