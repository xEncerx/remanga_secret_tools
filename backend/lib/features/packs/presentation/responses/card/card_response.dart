import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_response.freezed.dart';
part 'card_response.g.dart';

/// Response model representing a card with various attributes.
@freezed
abstract class CardResponse with _$CardResponse {
  /// Factory constructor for [CardResponse].
  const factory CardResponse({
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

    /// Count of encounters associated with the card.
    required int encounterCount,

    /// Cover image URL of the card.
    required String cover,
  }) = _CardResponse;

  /// Creates a [CardResponse] from a JSON map.
  factory CardResponse.fromJson(Map<String, dynamic> json) =>
      _$CardResponseFromJson(json);
}
