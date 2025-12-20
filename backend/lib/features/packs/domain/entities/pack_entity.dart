import 'package:backend/features/packs/domain/entities/entities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_entity.freezed.dart';
part 'pack_entity.g.dart';

/// Entity representing a pack with various attributes.
@freezed
abstract class PackEntity with _$PackEntity {
  /// Factory constructor for [PackEntity].
  const factory PackEntity({
    /// Unique identifier for the pack.
    required int id,

    /// Name of the pack.
    required String name,

    /// Description of the pack.
    required String description,

    /// Level information of the pack.
    required PackLevelEntity level,

    /// Indicates if the pack is currently active.
    required bool isActive,

    /// Type of the pack.
    required String type,

    /// [PackGuarantorsEntity] representing the pack's guarantors.
    required PackGuarantorsEntity guarantors,

    /// List of [CardEntity] representing the cards in the pack.
    required List<CardEntity> cards,

    /// Cost of the pack.
    @Default(-1) int cost,

    /// Directory path related to the pack.
    @Default('') String dir,

    /// Amount associated with the pack, if any.
    @Default(-1) int amount,
  }) = _PackEntity;

  /// Creates a [PackEntity] from a JSON map.
  factory PackEntity.fromJson(Map<String, dynamic> json) =>
      _$PackEntityFromJson(json);
}
