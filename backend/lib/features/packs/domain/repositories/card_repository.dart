import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';

/// Repository for managing card data.
abstract class CardRepository {
  /// Finds a card by its ID.
  Future<CardsDbModelData?> findById(int id);

  /// Finds cards by their status.
  Future<List<CardsDbModelData>> findByStatus(
    DownloadStatus status, {
    int? limit,
  });

  /// Counts cards grouped by their rank in a specific pack.
  Future<Map<CardRankEnum, int>> countCardsByRank(int packId);

  /// Upserts a card into the database.
  Future<void> upsert({required CardsDbModelData card, required int packId});

  /// Updates the cover status of a card.
  Future<void> updateCoverStatus(int cardId, DownloadStatus status);
}
