import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';

/// Data source for pack operations.
abstract class PackLocalDataSource {
  /// Inserts or updates a pack in the database.
  Future<void> upsertPack({required PackEntity pack, required String packHash});

  /// Retrieves a pack by its ID from the database.
  Future<Pack?> getPackById({required int packId});
}
