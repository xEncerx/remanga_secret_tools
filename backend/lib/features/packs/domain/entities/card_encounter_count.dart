import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_encounter_count.freezed.dart';
part 'card_encounter_count.g.dart';

/// A data class representing the count of encounters for card in packs.
@freezed
abstract class CardEncounterCount with _$CardEncounterCount {
  /// Creates an [CardEncounterCount] instance.
  const factory CardEncounterCount({
    @Default(1) int pack10,
  }) = _CardEncounterCount;

  /// Creates an [CardEncounterCount] instance from a JSON map.
  factory CardEncounterCount.fromJson(Map<String, dynamic> json) =>
      _$CardEncounterCountFromJson(json);

  /// Generates a key string for a given pack ID.
  static String getKeyById(int packId) => 'pack$packId';
}
