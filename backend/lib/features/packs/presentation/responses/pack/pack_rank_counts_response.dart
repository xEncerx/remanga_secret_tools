import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_rank_counts_response.freezed.dart';
part 'pack_rank_counts_response.g.dart';

/// Response representing the counts of different ranks of cards in a pack.
@freezed
abstract class PackRankCountsResponse with _$PackRankCountsResponse {
  /// Factory constructor for [PackRankCountsResponse].
  const factory PackRankCountsResponse({
    required int rankS,
    required int rankA,
    required int rankB,
    required int rankC,
    required int rankD,
    required int rankE,
    required int rankF,
  }) = _PackRankCountsResponse;

  /// Creates a [PackRankCountsResponse] from a JSON map.
  factory PackRankCountsResponse.fromJson(Map<String, dynamic> json) =>
      _$PackRankCountsResponseFromJson(json);
}
