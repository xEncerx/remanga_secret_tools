import 'dart:convert';

import 'package:backend/core/core.dart';
import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';
import 'package:crypto/crypto.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for syncing pack data from the API to the local database.
class SyncPackUseCase {
  /// Creates a [SyncPackUseCase] instance.
  SyncPackUseCase({
    required this.restClient,
    required this.packRepository,
    required this.cardRepository,
    required this.packHashGenerator,
  });

  /// RestClient for making API calls.
  final RestClient restClient;

  /// Pack repository for database operations.
  final PackRepository packRepository;

  /// Card repository for database operations.
  final CardRepository cardRepository;

  /// Generator for pack hash.
  final PackHashGenerator packHashGenerator;

  /// Executes the sync process for a specific pack.
  Future<SyncResult> execute(int packId) async {
    try {
      final results = await Future.wait([
        restClient.packs.getPackById(packId),
        restClient.packs.getPackDetailById(packId),
      ]);

      final packData = results[0] as Either<ApiException, PackEntity>;
      final packDetail =
          results[1]
              as Either<
                ApiException,
                PaginationResponseEntity<PackDetailEntity>
              >;

      return packData.fold(
        (error) => SyncResult.failure(
          message: 'Pack fetch failed: ${error.detail}',
          exception: error,
        ),
        (pack) => packDetail.fold(
          (error) => SyncResult.failure(
            message: 'Pack detail fetch failed: ${error.detail}',
            exception: error,
          ),
          (detail) async {
            final enrichedPack = _enrichPack(pack, detail);
            final newHash = packHashGenerator.generate(enrichedPack);

            final existingPack = await packRepository.findById(packId);

            if (existingPack?.packHash == newHash) {
              return SyncResult.success(SyncData.unchanged());
            }

            await _syncPackData(enrichedPack, newHash);

            return SyncResult.success(
              SyncData.updated(cardsAdded: enrichedPack.cards.length),
            );
          },
        ),
      );
    } catch (e, st) {
      return SyncResult.failure(
        message: 'Failed to sync pack $packId',
        exception: e,
        stackTrace: st,
      );
    }
  }

  PackEntity _enrichPack(
    PackEntity pack,
    PaginationResponseEntity<PackDetailEntity> detail,
  ) {
    if (detail.results.isEmpty) return pack;

    final firstDetail = detail.results[0];
    return pack.copyWith(
      cost: firstDetail.cost,
      dir: firstDetail.dir,
      amount: firstDetail.amount,
    );
  }

  Future<void> _syncPackData(PackEntity pack, String newHash) async {
    await packRepository.transaction(() async {
      // 1. Upsert pack metadata
      await packRepository.upsert(
        PacksDbModelData(
          id: pack.id,
          name: pack.name,
          description: HtmlCleaner.clean(pack.description),
          packHash: newHash,
          level: pack.level,
          isActive: pack.isActive,
          type: pack.type,
          guarantors: pack.guarantors,
          cost: pack.cost,
          dir: pack.dir,
          amount: pack.amount,
          updatedAt: PgDateTime(DateTime.now()),
        ),
      );

      // 2. Upsert cards (with cover metadata)
      final cardIds = <int>[];
      for (final card in pack.cards) {
        final coverOriginalUrl = card.cover.high ?? card.cover.mid ?? '';

        await cardRepository.upsert(
          card: CardsDbModelData(
            id: card.id,
            description: HtmlCleaner.clean(card.description),
            score: card.score,
            rank: CardRankEnum.fromString(card.rank),
            power: card.power,
            hasAudio: card.hasAudio,
            isUpgradable: card.isUpgradable,
            encounterCount: const CardEncounterCount(),
            coverOriginalUrl: coverOriginalUrl,
            coverLocalPath: _generateLocalPath(coverOriginalUrl),
            coverStatus: DownloadStatus.pending,
            updatedAt: PgDateTime(DateTime.now()),
          ),
          packId: pack.id,
        );
        cardIds.add(card.id);
      }
      await packRepository.replacePackCards(pack.id, cardIds);
    });
  }

  String _generateLocalPath(String originalUrl) {
    if (originalUrl.isEmpty) return EnvConfig.apiErrorCoverPath;

    final hash = sha256
        .convert(utf8.encode(originalUrl))
        .toString()
        .substring(0, 16);
    final extension = originalUrl.split('.').last.split('?').first;

    return '${EnvConfig.apiCardsCoverPath}$hash.$extension';
  }
}
