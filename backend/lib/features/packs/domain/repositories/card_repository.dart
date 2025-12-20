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

  /// Upserts a card into the database.
  Future<void> upsert(CardsDbModelData card);

  /// Updates the cover status of a card.
  Future<void> updateCoverStatus(int cardId, DownloadStatus status);
}
