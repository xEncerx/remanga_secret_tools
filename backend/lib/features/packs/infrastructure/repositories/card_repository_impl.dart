import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';

/// Implementation of the [CardRepository] using Drift for database operations.
class CardRepositoryImpl implements CardRepository {
  /// Creates a new instance of [CardRepositoryImpl].
  CardRepositoryImpl(this.database);

  /// The database instance used for database operations.
  final AppDatabase database;

  @override
  Future<CardsDbModelData?> findById(int id) async {
    return (database.select(
      database.cardsDbModel,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<List<CardsDbModelData>> findByStatus(
    DownloadStatus status, {
    int? limit,
  }) async {
    final query = database.select(database.cardsDbModel)
      ..where((t) => t.coverStatus.equals(status.name));

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }

  @override
  Future<void> updateCoverStatus(int cardId, DownloadStatus status) async {
    await (database.update(database.cardsDbModel)
          ..where((t) => t.id.equals(cardId)))
        .write(CardsDbModelCompanion(coverStatus: Value(status)));
  }

  @override
  Future<void> upsert(CardsDbModelData card) async {
    await database.into(database.cardsDbModel).insertOnConflictUpdate(card);
  }
}
