import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Implementation of [PackLocalDataSource] using a database.
class PackLocalDataSourceImpl implements PackLocalDataSource {
  /// Creates an instance of [PackLocalDataSourceImpl] with the given [AppDatabase].
  PackLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<Pack?> getPackById({required int packId}) async {
    final query = _database.select(_database.packs)
      ..where((tbl) => tbl.packId.equals(packId));

    final result = await query.getSingleOrNull();
    return result;
  }

  @override
  Future<void> upsertPack({
    required PackEntity pack,
    required String packHash,
  }) async {
    await _database
        .into(_database.packs)
        .insertOnConflictUpdate(
          PacksCompanion.insert(
            packId: Value(pack.id),
            rawPackData: pack,
            packHash: packHash,
            updatedAt: Value(PgDateTime(DateTime.now())),
          ),
        );
  }
}
