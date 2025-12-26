import 'package:backend/features/features.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_response.freezed.dart';
part 'pack_response.g.dart';

/// Response model representing a pack with various attributes.
@freezed
abstract class PackResponse with _$PackResponse {
  /// Factory constructor for [PackResponse].
  const factory PackResponse({
    /// Unique identifier for the pack.
    required int id,

    /// Name of the pack.
    required String name,

    /// Description of the pack.
    required String description,

    /// Level information of the pack.
    required PackLevelResponse level,

    /// Indicates if the pack is currently active.
    required bool isActive,

    /// Type of the pack.
    required String type,

    /// [PackGuarantorsResponse] representing the pack's guarantors.
    required PackGuarantorsResponse guarantors,

    /// List of [CardResponse] representing the cards in the pack.
    required List<CardResponse> cards,

    /// Rank counts of the cards in the pack.
    required PackRankCountsResponse packRankCounts,

    /// Cost of the pack.
    required int cost,

    /// Directory path related to the pack.
    required String dir,

    /// Amount associated with the pack, if any.
    required int amount,
  }) = _PackResponse;

  /// Creates a [PackResponse] from a JSON map.
  factory PackResponse.fromJson(Map<String, dynamic> json) =>
      _$PackResponseFromJson(json);
}
