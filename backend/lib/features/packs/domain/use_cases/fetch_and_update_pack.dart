import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for fetching a pack by its ID and updating the data if necessary.
class FetchAndUpdatePack {
  /// Creates an instance of [FetchAndUpdatePack].
  FetchAndUpdatePack({
    required this.restClient,
    required this.packLocalDataSource,
  });

  /// The REST client used to fetch pack data.
  final RestClient restClient;

  /// The local data source for packs.
  final PackLocalDataSource packLocalDataSource;

  /// Fetches a pack by its ID and updates the pack data if necessary.
  Future<void> execute(int packId) async {
    final results = await Future.wait([
      restClient.packs.getPackById(packId),
      restClient.packs.getPackDetailById(packId),
    ]);

    final packData = results[0] as Either<ApiException, PackEntity>;
    final packDetail =
        results[1]
            as Either<ApiException, PaginationResponseEntity<PackDetailEntity>>;

    packData.fold(
      (packError) =>
          throw Exception('Failed to fetch pack $packId: ${packError.detail}'),
      (pack) => packDetail.fold(
        (detailError) => throw Exception(
          'Failed to fetch pack detail $packId: ${detailError.detail}',
        ),
        (detail) {
          final packToSave = detail.results.isNotEmpty
              ? pack.copyWith(
                  cost: detail.results[0].cost,
                  dir: detail.results[0].dir,
                  amount: detail.results[0].amount,
                )
              : pack;
          _upsertPack(packToSave);
        },
      ),
    );
  }

  Future<void> _upsertPack(PackEntity pack) async {
    final packHash = PackHashGenerator().generate(pack);

    final existingPack = await packLocalDataSource.getPackById(packId: pack.id);

    // If the pack exists and hasn't changed, do nothing.
    if (existingPack != null &&
        !PackHashGenerator().hasChanged(existingPack.rawPackData, packHash)) {
      return;
    }

    await packLocalDataSource.upsertPack(pack: pack, packHash: packHash);
  }
}
