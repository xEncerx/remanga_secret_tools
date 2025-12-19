import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'pack_dto.freezed.dart';
part 'pack_dto.g.dart';

/// DTO representing a pack with various attributes.
@freezed
abstract class PackDTO with _$PackDTO {
  /// Factory constructor for [PackDTO].
  const factory PackDTO({
    /// Unique identifier for the pack.
    required int id,

    /// Name of the pack.
    required String name,

    /// Cost of the pack.
    required int cost,

    /// Directory path related to the pack.
    required String dir,

    /// Amount associated with the pack, if any.
    required int amount,

    /// Description of the pack.
    required String description,

    /// Level information of the pack.
    required PackLevelDTO level,

    /// Indicates if the pack is currently active.
    required bool isActive,

    /// Type of the pack.
    required String type,

    /// [PackGuarantorsDTO] representing the pack's guarantors.
    required PackGuarantorsDTO guarantors,

    /// List of [CardDTO] representing the cards in the pack.
    required List<CardDTO> cards,
  }) = _PackDTO;

  /// Creates a [PackDTO] from a JSON map.
  factory PackDTO.fromJson(Map<String, dynamic> json) =>
      _$PackDTOFromJson(json);
}
