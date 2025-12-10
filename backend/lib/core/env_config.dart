import 'package:dotenv/dotenv.dart';

/// A class to manage environment configurations using dotenv.
class EnvConfig {
  static final _dotenv = DotEnv()..load();

  /// The API url of Remanga.
  static String get apiRemangaUrl =>
      _dotenv['API_REMANGA_URL'] ?? 'http://api.remanga.org';

  // === Database configuration parameters. ===
  /// The host of the database.
  static String get dbHost => _dotenv['DB_HOST'] ?? 'localhost';

  /// The port of the database.
  static int get dbPort => int.parse(_dotenv['DB_PORT'] ?? '5432');

  /// The name of the database.
  static String get dbName => _dotenv['DB_NAME'] ?? 'remanga_db';

  /// The user for the database.
  static String get dbUser => _dotenv['DB_USER'] ?? 'postgres';

  /// The password for the database.
  static String get dbPassword => _dotenv['DB_PASSWORD'] ?? '';

  // === Redis configuration parameters. ===
  /// The host of the Redis server.
  static String get redisHost => _dotenv['REDIS_HOST'] ?? 'localhost';

  /// The port of the Redis server.
  static int get redisPort => int.parse(_dotenv['REDIS_PORT'] ?? '6379');

  /// The password for the Redis server.
  static String? get redisPassword => _dotenv['REDIS_PASSWORD'];

  /// The database index for the Redis server.
  static int get redisDatabase => int.parse(_dotenv['REDIS_DATABASE'] ?? '0');
}
