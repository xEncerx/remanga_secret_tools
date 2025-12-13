import 'package:dotenv/dotenv.dart';

/// A class to manage environment configurations using dotenv.
class EnvConfig {
  static final _dotenv = DotEnv()..load();

  /// The current environment flavor.
  static EnvFlavor get flavor =>
      EnvFlavor.fromString(_dotenv['FLAVOR'] ?? 'dev');

  // === Site configuration. ===
  /// The allowed origin for CORS.
  static String get allowedOrigin {
    final origin = _dotenv['ALLOWED_ORIGIN'];
    if (flavor == EnvFlavor.development) {
      // Allow wildcard in development for convenience.
      return origin ?? '*';
    } else {
      if (origin == null || origin.trim().isEmpty || origin == '*') {
        throw StateError(
          'ALLOWED_ORIGIN must be set to a specific origin in production/staging environments. Wildcard "*" is not allowed.',
        );
      }
      return origin;
    }
  }

  /// The API url of Remanga.
  static String get apiRemangaUrl =>
      _dotenv['API_REMANGA_URL'] ?? 'https://api.remanga.org';

  // === Logging configuration parameters. ===
  /// The Sentry DSN for error tracking.
  static String? get sentryDsn => _dotenv['SENTRY_DSN'];

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

/// The different environment flavors.
enum EnvFlavor {
  /// Development environment.
  development('dev'),

  /// Staging environment.
  staging('stage'),

  /// Production environment.
  production('prod');

  const EnvFlavor(this.name);

  /// The name of the flavor.
  final String name;

  /// Creates an [EnvFlavor] from a string.
  static EnvFlavor fromString(String flavor) {
    return EnvFlavor.values.firstWhere(
      (e) => e.name == flavor,
      orElse: () => EnvFlavor.development,
    );
  }
}
