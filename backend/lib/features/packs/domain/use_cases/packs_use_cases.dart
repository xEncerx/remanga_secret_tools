import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';

/// A collection of use cases related to packs.
class PacksUseCases {
  /// Creates an instance of [PacksUseCases].
  PacksUseCases({
    required this.restClient,
    required this.packLocalDataSource,
  }) {
    _initializeUseCases();
  }

  /// The REST client used for making network requests.
  final RestClient restClient;

  /// The local data source for packs.
  final PackLocalDataSource packLocalDataSource;

  late final FetchAndUpdatePack _fetchAndUpdatePack;
  late final GetPackById _getPackById;

  void _initializeUseCases() {
    _fetchAndUpdatePack = FetchAndUpdatePack(
      restClient: restClient,
      packLocalDataSource: packLocalDataSource,
    );
    _getPackById = GetPackById(
      packLocalDataSource: packLocalDataSource,
    );
  }

  // === Public API methods ===
  /// Fetches and updates a pack by its ID.
  Future<void> fetchAndUpdatePack(int packId) =>
      _fetchAndUpdatePack.execute(packId);

  /// Retrieves a pack by its ID.
  Future<PackEntity?> getPackById(int packId) => _getPackById.execute(packId);
}
