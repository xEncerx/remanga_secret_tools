import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_level_dto.freezed.dart';
part 'pack_level_dto.g.dart';

/// DTO representing a pack level with various attributes.
@freezed
abstract class PackLevelDTO with _$PackLevelDTO {
  /// Factory constructor for [PackLevelDTO].
  const factory PackLevelDTO({
    /// Unique identifier for the pack level.
    required int id,
    /// Name of the pack level.
    required String name,
    /// Description of the pack level.
    required String description,
  }) = _PackLevelDTO;

  /// Creates a [PackLevelDTO] from a JSON map.
  factory PackLevelDTO.fromJson(Map<String, dynamic> json) =>
      _$PackLevelDTOFromJson(json);
}
