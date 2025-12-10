import 'package:freezed_annotation/freezed_annotation.dart';

part 'cover_entity.freezed.dart';
part 'cover_entity.g.dart';

/// Entity representing cover images with different resolutions.
@freezed
abstract class CoverEntity with _$CoverEntity {
  /// Factory constructor for [CoverEntity].
  const factory CoverEntity({
    /// URL for medium resolution cover image.
    required String? mid,

    /// URL for high resolution cover image.
    required String? high,
  }) = _CoverEntity;

  /// Creates a [CoverEntity] from a JSON map.
  factory CoverEntity.fromJson(Map<String, dynamic> json) =>
      _$CoverEntityFromJson(json);
}
