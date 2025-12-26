import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

part 'app_database.g.dart';

/// The main application database class using Drift.
@DriftDatabase(tables: [PacksDbModel, PackCardsDbModel, CardsDbModel])
class AppDatabase extends _$AppDatabase {
  /// Creates an instance of [AppDatabase] with the given [QueryExecutor].
  AppDatabase(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_cards_rank ON cards(rank)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_cards_encounter_count ON cards USING GIN (encounter_count)',
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Perform migration from version 1 to 2
        if (from == 1 && to >= 2) {
          await customStatement(
            // ignore: lines_longer_than_80_chars
            "ALTER TABLE cards ADD COLUMN encounter_count JSONB NOT NULL DEFAULT '{}'::jsonb",
          );
        }
        // Perform migration from version 2 to 3
        if (from <= 2 && to >= 3) {
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_cards_rank ON cards(rank)',
          );
          await customStatement(
            // ignore: lines_longer_than_80_chars
            'CREATE INDEX IF NOT EXISTS idx_cards_encounter_count ON cards USING GIN (encounter_count)',
          );
        }
      },
    );
  }
}
