import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_rank_counts_dto.freezed.dart';
part 'pack_rank_counts_dto.g.dart';

/// DTO representing the counts of different card ranks in a pack.
@freezed
abstract class PackRankCountsDTO with _$PackRankCountsDTO {
  /// Factory constructor for [PackRankCountsDTO].
  const factory PackRankCountsDTO({
    required int rankS,
    required int rankA,
    required int rankB,
    required int rankC,
    required int rankD,
    required int rankE,
    required int rankF,
  }) = _PackRankCountsDTO;

  /// Creates a [PackRankCountsDTO] from a JSON map.
  factory PackRankCountsDTO.fromJson(Map<String, dynamic> json) =>
      _$PackRankCountsDTOFromJson(json);
}
