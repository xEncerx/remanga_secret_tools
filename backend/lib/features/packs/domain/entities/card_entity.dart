import 'package:backend/features/packs/domain/entities/entities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_entity.freezed.dart';
part 'card_entity.g.dart';

/// Entity representing a card with various attributes.
@freezed
abstract class CardEntity with _$CardEntity {
  /// Factory constructor for [CardEntity].
  const factory CardEntity({
    /// Unique identifier for the card.
    required int id,

    /// Description of the card.
    required String description,

    /// Score value of the card.
    required int score,

    /// Rank of the card. (e.g., "rank_S", "rank_A", etc.)
    required String rank,

    /// Power level of the card.
    required int power,

    /// Indicates if the card has associated audio.
    required bool hasAudio,

    /// Indicates if the card can be upgraded.
    required bool isUpgradable,

    /// [CoverEntity] representing the card's cover images.
    required CoverEntity cover,
  }) = _CardEntity;

  /// Creates a [CardEntity] from a JSON map.
  factory CardEntity.fromJson(Map<String, dynamic> json) =>
      _$CardEntityFromJson(json);
}
