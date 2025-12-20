import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_level_entity.freezed.dart';
part 'pack_level_entity.g.dart';

/// Entity representing a pack level with various attributes.
@freezed
abstract class PackLevelEntity with _$PackLevelEntity {
  /// Factory constructor for [PackLevelEntity].
  const factory PackLevelEntity({
    /// Unique identifier for the pack level.
    required int id,

    /// Name of the pack level.
    required String name,

    /// Description of the pack level.
    required String description,
  }) = _PackLevelEntity;

  /// Creates a [PackLevelEntity] from a JSON map.
  factory PackLevelEntity.fromJson(Map<String, dynamic> json) =>
      _$PackLevelEntityFromJson(json);
}
