import 'package:freezed_annotation/freezed_annotation.dart';

part 'pack_guarantors_response.freezed.dart';
part 'pack_guarantors_response.g.dart';

/// Response representing pack rank guarantors with various attributes.
@freezed
abstract class PackRankGuarantorsResponse with _$PackRankGuarantorsResponse {
  /// Factory constructor for [PackRankGuarantorsResponse].
  const factory PackRankGuarantorsResponse({
    /// Number of rank A guarantors.
    required int rankA,

    /// Number of rank S guarantors.
    required int rankS,
  }) = _PackRankGuarantorsResponse;

  /// Creates a [PackRankGuarantorsResponse] from a JSON map.
  factory PackRankGuarantorsResponse.fromJson(Map<String, dynamic> json) =>
      _$PackRankGuarantorsResponseFromJson(json);
}

/// Response representing pack guarantors with various attributes.
@freezed
abstract class PackGuarantorsResponse with _$PackGuarantorsResponse {
  /// Factory constructor for [PackGuarantorsResponse].
  const factory PackGuarantorsResponse({
    /// Unique identifier for the pack guarantors.
    required int id,

    /// Name of the pack guarantors.
    required String name,

    /// [PackRankGuarantorsResponse] representing the rank guarantors.
    required PackRankGuarantorsResponse guarantors,
  }) = _PackGuarantorsResponse;

  /// Creates a [PackGuarantorsResponse] from a JSON map.
  factory PackGuarantorsResponse.fromJson(Map<String, dynamic> json) =>
      _$PackGuarantorsResponseFromJson(json);
}
