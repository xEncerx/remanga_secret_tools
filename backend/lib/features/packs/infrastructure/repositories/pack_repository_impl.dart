import 'package:backend/database/app_database.dart';
import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';

/// Implementation of the [PackRepository] interface.
class PackRepositoryImpl implements PackRepository {
  /// Creates a new instance of [PackRepositoryImpl].
  PackRepositoryImpl(this.database);

  /// The database instance used to interact with the database.
  final AppDatabase database;

  @override
  Future<PacksDbModelData?> findById(int id) async {
    return (database.select(
      database.packsDbModel,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<void> replacePackCards(int packId, List<int> cardIds) {
    return database.transaction(() async {
      // 1. Delete all existing relationships for this pack
      await (database.delete(
        database.packCardsDbModel,
      )..where((t) => t.packId.equals(packId))).go();
      // 2. Insert new relationships
      if (cardIds.isNotEmpty) {
        await database.batch((batch) {
          for (final cardId in cardIds) {
            batch.insert(
              database.packCardsDbModel,
              PackCardsDbModelCompanion.insert(
                packId: packId,
                cardId: cardId,
              ),
              mode: InsertMode.insertOrIgnore, // Skip duplicates
            );
          }
        });
      }
    });
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) {
    return database.transaction(() => action());
  }

  @override
  Future<void> upsert(PacksDbModelData pack) async {
    await database.into(database.packsDbModel).insertOnConflictUpdate(pack);
  }

  @override
  Future<(PacksDbModelData, List<CardsDbModelData>)?> findByIdWithCards(
    int id,
  ) async {
    final pack = await findById(id);

    if (pack == null) return null;

    final query = database.select(database.cardsDbModel).join([
      innerJoin(
        database.packCardsDbModel,
        database.packCardsDbModel.cardId.equalsExp(database.cardsDbModel.id),
      ),
    ])..where(database.packCardsDbModel.packId.equals(id));

    final rows = await query.get();
    final cards = rows
        .map((row) => row.readTable(database.cardsDbModel))
        .toList();

    // Sort cards by rank
    _sortCardsByRank(cards);

    return (pack, cards);
  }

  void _sortCardsByRank(List<CardsDbModelData> cards) {
    cards.sort(
      (a, b) => a.rank.index.compareTo(b.rank.index),
    );
  }
}
