import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_guarantors_dto.freezed.dart';
part 'pack_guarantors_dto.g.dart';

/// DTO representing pack rank guarantors with various attributes.
@freezed
abstract class PackRankGuarantorsDTO with _$PackRankGuarantorsDTO {
  /// Factory constructor for [PackRankGuarantorsDTO].
  const factory PackRankGuarantorsDTO({
    /// Number of rank A guarantors.
    required int rankA,

    /// Number of rank S guarantors.
    required int rankS,
  }) = _PackRankGuarantorsDTO;

  /// Creates a [PackRankGuarantorsDTO] from a JSON map.
  factory PackRankGuarantorsDTO.fromJson(Map<String, dynamic> json) =>
      _$PackRankGuarantorsDTOFromJson(json);
}

/// DTO representing pack guarantors with various attributes.
@freezed
abstract class PackGuarantorsDTO with _$PackGuarantorsDTO {
  /// Factory constructor for [PackGuarantorsDTO].
  const factory PackGuarantorsDTO({
    /// Unique identifier for the pack guarantors.
    required int id,

    /// Name of the pack guarantors.
    required String name,

    /// [PackRankGuarantorsDTO] representing the rank guarantors.
    required PackRankGuarantorsDTO guarantors,
  }) = _PackGuarantorsDTO;

  /// Creates a [PackGuarantorsDTO] from a JSON map.
  factory PackGuarantorsDTO.fromJson(Map<String, dynamic> json) =>
      _$PackGuarantorsDTOFromJson(json);
}
