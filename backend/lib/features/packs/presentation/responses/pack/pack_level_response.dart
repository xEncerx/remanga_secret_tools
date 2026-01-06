import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_level_response.freezed.dart';
part 'pack_level_response.g.dart';

/// Response representing a pack level with various attributes.
@freezed
abstract class PackLevelResponse with _$PackLevelResponse {
  /// Factory constructor for [PackLevelResponse].
  const factory PackLevelResponse({
    /// Unique identifier for the pack level.
    required int id,

    /// Name of the pack level.
    required String name,

    /// Description of the pack level.
    required String description,
  }) = _PackLevelResponse;

  /// Creates a [PackLevelResponse] from a JSON map.
  factory PackLevelResponse.fromJson(Map<String, dynamic> json) =>
      _$PackLevelResponseFromJson(json);
}
