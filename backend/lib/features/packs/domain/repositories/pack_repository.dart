import 'package:backend/database/database.dart';

/// Repository for managing packs in the database
abstract class PackRepository {
  /// Finds a pack by its ID
  Future<PacksDbModelData?> findById(int id);

  /// Upserts a pack into the database
  Future<void> upsert(PacksDbModelData pack);

  /// Replaces all cards for a pack (clears old relationships + inserts new)
  Future<void> replacePackCards(int packId, List<int> cardIds);

  /// Finds a pack by its ID along with its associated cards
  Future<(PacksDbModelData, List<CardsDbModelData>)?> findByIdWithCards(int id);

  /// Executes multiple operations in a transaction
  Future<T> transaction<T>(Future<T> Function() action);
}
