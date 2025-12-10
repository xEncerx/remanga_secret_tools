import 'package:backend/features/features.dart';

/// Use case for retrieving a pack by its ID.
class GetPackById {
  /// Creates an instance of [GetPackById].
  GetPackById({
    required this.packLocalDataSource,
  });

  /// The local data source for packs.
  final PackLocalDataSource packLocalDataSource;

  /// Retrieves a pack by its ID.
  Future<PackEntity?> execute(int packId) async {
    final dbResult = await packLocalDataSource.getPackById(packId: packId);
    return dbResult?.rawPackData;
  }
}
