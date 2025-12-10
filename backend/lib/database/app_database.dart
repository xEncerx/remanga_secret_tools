import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

part 'app_database.g.dart';

/// The main application database class using Drift.
@DriftDatabase(tables: [Packs])
class AppDatabase extends _$AppDatabase {
  /// Creates an instance of [AppDatabase] with the given [QueryExecutor].
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Maybe will add migrations later
      },
    );
  }
}
