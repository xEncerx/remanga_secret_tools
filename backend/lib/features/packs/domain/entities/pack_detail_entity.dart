import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_detail_entity.freezed.dart';
part 'pack_detail_entity.g.dart';

/// Entity representing detailed information about a pack.
@freezed
abstract class PackDetailEntity with _$PackDetailEntity {
  /// Factory constructor for [PackDetailEntity].
  const factory PackDetailEntity({
    required int id,
    required int cost,
    required String dir,
    required int? amount,
  }) = _PackDetailEntity;

  /// Creates a [PackDetailEntity] from a JSON map.
  factory PackDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$PackDetailEntityFromJson(json);
}
