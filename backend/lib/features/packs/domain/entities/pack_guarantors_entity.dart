import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_guarantors_entity.freezed.dart';
part 'pack_guarantors_entity.g.dart';

/// Entity representing pack rank guarantors with various attributes.
@freezed
abstract class PackRankGuarantorsEntity with _$PackRankGuarantorsEntity {
  /// Factory constructor for [PackRankGuarantorsEntity].
  const factory PackRankGuarantorsEntity({
    /// Number of rank A guarantors.
    required int rankA,
    /// Number of rank S guarantors.
    required int rankS,
  }) = _PackRankGuarantorsEntity;

  /// Creates a [PackRankGuarantorsEntity] from a JSON map.
  factory PackRankGuarantorsEntity.fromJson(Map<String, dynamic> json) =>
      _$PackRankGuarantorsEntityFromJson(json);
}

/// Entity representing pack guarantors with various attributes.
@freezed
abstract class PackGuarantorsEntity with _$PackGuarantorsEntity{
  /// Factory constructor for [PackGuarantorsEntity].
  const factory PackGuarantorsEntity({
    /// Unique identifier for the pack guarantors.
    required int id,
    /// Name of the pack guarantors.
    required String name,
    /// [PackRankGuarantorsEntity] representing the rank guarantors.
    required PackRankGuarantorsEntity guarantors,
  }) = _PackGuarantorsEntity;

  /// Creates a [PackGuarantorsEntity] from a JSON map.
  factory PackGuarantorsEntity.fromJson(Map<String, dynamic> json) =>
      _$PackGuarantorsEntityFromJson(json);
}
