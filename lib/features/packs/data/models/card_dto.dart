import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'card_dto.freezed.dart';
part 'card_dto.g.dart';

/// DTO representing a card with various attributes.
@freezed
abstract class CardDTO with _$CardDTO {
  /// Factory constructor for [CardDTO].
  const factory CardDTO({
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

    /// [CoverDTO] representing the card's cover images.
    required CoverDTO cover,
  }) = _CoverDTO;

  /// Creates a [CardDTO] from a JSON map.
  factory CardDTO.fromJson(Map<String, dynamic> json) =>
      _$CoverDTOFromJson(json);
}
