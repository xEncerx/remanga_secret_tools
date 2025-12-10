import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_response_entity.freezed.dart';
part 'pagination_response_entity.g.dart';

/// Generic entity for paginated API responses.
@Freezed(genericArgumentFactories: true)
abstract class PaginationResponseEntity<T> with _$PaginationResponseEntity<T> {
  /// Factory constructor for [PaginationResponseEntity].
  const factory PaginationResponseEntity({
    required String? next,
    required String? previous,
    required List<T> results,
  }) = _PaginationResponseEntity<T>;

  /// Creates a [PaginationResponseEntity] from a JSON map.
  factory PaginationResponseEntity.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginationResponseEntityFromJson<T>(json, fromJsonT);
}
