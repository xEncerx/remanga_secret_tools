import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';

/// Use case for retrieving a pack by its ID.
class GetPackUseCase {
  /// Creates an instance of [GetPackUseCase].
  GetPackUseCase(this.packRepository);

  /// The repository for packs.
  final PackRepository packRepository;

  /// Retrieves a pack by its ID.
  Future<PackEntity?> execute(int packId) async {
    final result = await packRepository.findByIdWithCards(packId);
    if (result == null) return null;

    final (pack, cards) = result;

    return PackEntity(
      id: pack.id,
      name: pack.name,
      description: pack.description,
      level: pack.level,
      isActive: pack.isActive,
      type: pack.type,
      guarantors: pack.guarantors,
      cost: pack.cost,
      dir: pack.dir,
      amount: pack.amount,
      cards: cards.map(_mapCardToEntity).toList(),
    );
  }

  CardEntity _mapCardToEntity(CardsDbModelData card) {
    return CardEntity(
      id: card.id,
      description: card.description,
      score: card.score,
      rank: card.rank.name,
      power: card.power,
      hasAudio: card.hasAudio,
      isUpgradable: card.isUpgradable,
      cover: CoverEntity(
        mid: card.coverLocalPath,
        high: card.coverLocalPath,
      ),
    );
  }
}
