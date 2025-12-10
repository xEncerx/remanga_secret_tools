import 'dart:async';

import 'package:backend/features/features.dart';

/// In-memory implementation of [CacheService].
class InMemoryCacheService implements CacheService {
  final Map<String, CacheEntry> _cache = {};
  Timer? _cleanupTimer;

  /// Starts a periodic cleanup to remove expired cache entries.
  void startCleanup({Duration interval = const Duration(minutes: 5)}) {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(interval, (_) => _removeExpiredEntries());
  }

  void _removeExpiredEntries() {
    final now = DateTime.now();
    _cache.removeWhere((key, entry) {
      final isExpired =
          entry.expiresAt != null && now.isAfter(entry.expiresAt!);
      return isExpired;
    });
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }

  @override
  Future<void> delete(String key) async {
    _cache.remove(key);
  }

  @override
  Future<void> dispose() async {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    await clear();
  }

  @override
  Future<bool> exists(String key) async {
    final entry = _cache[key];
    if (entry == null) return false;

    if (entry.isExpired) {
      await delete(key);
      return false;
    }

    return true;
  }

  @override
  Future<String?> get(String key) async {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      await delete(key);
      return null;
    }

    return entry.value;
  }

  @override
  Future<void> set(String key, String value, {Duration? ttl}) async {
    final expiresAt = ttl != null ? DateTime.now().add(ttl) : null;
    _cache[key] = CacheEntry(value: value, expiresAt: expiresAt);
  }
}
