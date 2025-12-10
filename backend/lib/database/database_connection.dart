import 'package:backend/core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart';

/// Provides a connection to the PostgreSQL database.
class DatabaseConnection {
  /// Creates and returns a [QueryExecutor] for database operations.
  static QueryExecutor create() {
    final endpoint = Endpoint(
      host: EnvConfig.dbHost,
      port: EnvConfig.dbPort,
      database: EnvConfig.dbName,
      username: EnvConfig.dbUser,
      password: EnvConfig.dbPassword,
    );

    return PgDatabase(
      endpoint: endpoint,
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
        connectTimeout: Duration(seconds: 10),
      ),
    );
  }
}
