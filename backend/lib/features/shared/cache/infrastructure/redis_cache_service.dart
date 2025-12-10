import 'package:backend/features/features.dart';
import 'package:redis/redis.dart';

/// Redis implementation of [CacheService].
class RedisCacheService implements CacheService {
  /// Creates a new instance of [RedisCacheService].
  RedisCacheService({
    required String host,
    required int port,
    String? password,
    int database = 0,
  }) : _host = host,
       _port = port,
       _password = password,
       _database = database;
  final String _host;
  final int _port;
  final String? _password;
  final int _database;

  RedisConnection? _connection;
  Command? _command;
  bool _isConnected = false;

  /// Connects to the Redis server.
  Future<void> connect() async {
    if (_isConnected) return;

    try {
      _connection = RedisConnection();
      _command = await _connection!.connect(_host, _port);

      if (_password != null && _password.isNotEmpty) {
        await _command!.send_object(['AUTH', _password]);
      }

      if (_database != 0) {
        await _command!.send_object(['SELECT', _database.toString()]);
      }
      _isConnected = true;
    } catch (e) {
      _isConnected = false;
      throw Exception('Failed to connect to Redis: $e');
    }
  }

  void _ensureConnected() {
    if (!_isConnected || _command == null) {
      throw Exception('Redis client is not connected. Call connect() first.');
    }
  }

  @override
  Future<void> clear() async {
    _ensureConnected();

    await _command!.send_object(['FLUSHDB']);
  }

  @override
  Future<void> delete(String key) async {
    _ensureConnected();

    await _command!.send_object(['DEL', key]);
  }

  @override
  Future<void> dispose() async {
    if (_connection != null) {
      await _connection!.close();
      _isConnected = false;
      _command = null;
      _connection = null;
    }
  }

  @override
  Future<bool> exists(String key) async {
    _ensureConnected();

    final result = await _command!.send_object(['EXISTS', key]);
    return (result as int) == 1;
  }

  @override
  Future<String?> get(String key) async {
    _ensureConnected();

    try {
      final result = await _command!.send_object(['GET', key]);
      return result as String?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> set(String key, String value, {Duration? ttl}) async {
    _ensureConnected();

    if (ttl != null) {
      await _command!.send_object([
        'SETEX',
        key,
        ttl.inSeconds.toString(),
        value,
      ]);
    } else {
      await _command!.send_object(['SET', key, value]);
    }
  }
}
