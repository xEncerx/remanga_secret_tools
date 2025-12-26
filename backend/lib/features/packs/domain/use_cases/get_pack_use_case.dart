import 'package:backend/core/core.dart';
import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';

/// Use case for retrieving a pack by its ID.
class GetPackUseCase {
  /// Creates an instance of [GetPackUseCase].
  GetPackUseCase({
    required this.packRepository,
    required this.cardRepository,
  });

  /// The repository for packs.
  final PackRepository packRepository;

  /// The repository for cards.
  final CardRepository cardRepository;

  /// Retrieves a pack by its ID.
  Future<PackResponse?> execute(int packId) async {
    final result = await packRepository.findByIdWithCards(packId);
    if (result == null) return null;

    final (pack, cards) = result;
    final packKey = CardEncounterCount.getKeyById(packId);

    final rankCounts = await cardRepository.countCardsByRank(packId);

    return PackResponse(
      id: pack.id,
      name: pack.name,
      description: pack.description,
      level: PackLevelResponse.fromJson(
        pack.level.toJson(),
      ),
      isActive: pack.isActive,
      type: pack.type,
      guarantors: PackGuarantorsResponse(
        id: pack.guarantors.id,
        name: pack.guarantors.name,
        guarantors: PackRankGuarantorsResponse(
          rankA: pack.guarantors.guarantors.rankA,
          rankS: pack.guarantors.guarantors.rankS,
        ),
      ),
      packRankCounts: PackRankCountsResponse(
        rankS: rankCounts[CardRankEnum.rank_s] ?? 0,
        rankA: rankCounts[CardRankEnum.rank_a] ?? 0,
        rankB: rankCounts[CardRankEnum.rank_b] ?? 0,
        rankC: rankCounts[CardRankEnum.rank_c] ?? 0,
        rankD: rankCounts[CardRankEnum.rank_d] ?? 0,
        rankE: rankCounts[CardRankEnum.rank_e] ?? 0,
        rankF: rankCounts[CardRankEnum.rank_f] ?? 0,
      ),
      cost: pack.cost,
      dir: pack.dir,
      amount: pack.amount,
      cards: cards.map((card) => _mapCardToResponse(card, packKey)).toList(),
    );
  }

  CardResponse _mapCardToResponse(CardsDbModelData card, String packKey) {
    final encounterCount = card.encounterCount.toJson().cast<String, int>();

    return CardResponse(
      id: card.id,
      description: card.description,
      score: card.score,
      rank: card.rank.name,
      power: card.power,
      hasAudio: card.hasAudio,
      encounterCount: encounterCount[packKey] ?? 0,
      isUpgradable: card.isUpgradable,
      cover: card.coverLocalPath ?? EnvConfig.apiErrorCoverPath,
    );
  }
}
