// ignore_for_file: lines_longer_than_80_chars

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
  Future<Map<CardRankEnum, int>> countCardsByRank() async {
    final rankCounts = <CardRankEnum, int>{};

    final rankCount = database.cardsDbModel.id.count();
    final query = database.selectOnly(database.cardsDbModel)
      ..addColumns([database.cardsDbModel.rank, rankCount])
      ..groupBy([database.cardsDbModel.rank]);

    final results = await query.get();

    for (final row in results) {
      final rank = row.read(database.cardsDbModel.rank);
      final count = row.read(rankCount);

      if (rank != null && count != null) {
        rankCounts[CardRankEnum.fromString(rank)] = count;
      }
    }

    return rankCounts;
  }

  @override
  Future<void> updateCoverStatus(int cardId, DownloadStatus status) async {
    await (database.update(database.cardsDbModel)
          ..where((t) => t.id.equals(cardId)))
        .write(CardsDbModelCompanion(coverStatus: Value(status)));
  }

  @override
  Future<void> upsert({
    required CardsDbModelData card,
    required int packId,
  }) async {
    final packKey = CardEncounterCount.getKeyById(packId);

    await database
        .into(database.cardsDbModel)
        .insert(
          card,
          onConflict: DoUpdate(
            (_) => CardsDbModelCompanion.custom(
              score: Variable(card.score),
              encounterCount: CustomExpression(
                "jsonb_set(COALESCE(cards.encounter_count, '{}'::jsonb), '{$packKey}', "
                "(COALESCE(cards.encounter_count->>'$packKey', '0')::int + 1)::text::jsonb)",
              ),

              updatedAt: const CustomExpression('NOW()'),
            ),
            target: [database.cardsDbModel.id],
          ),
        );
  }
}
