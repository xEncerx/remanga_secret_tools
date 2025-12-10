import 'package:backend/features/features.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_error_response.freezed.dart';
part 'base_error_response.g.dart';

/// Base class for error responses.
@freezed
abstract class BaseErrorResponse with _$BaseErrorResponse {
  /// Creates a [BaseErrorResponse] instance.
  const factory BaseErrorResponse({
    /// The HTTP status code of the error.
    required int statusCode,

    /// A specific error code representing the error type.
    required ErrorCode errorCode,

    /// A detailed message describing the error.
    required String detail,
  }) = _BaseErrorResponse;

  /// Creates a [BaseErrorResponse] instance from a JSON map.
  factory BaseErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseErrorResponseFromJson(json);
}
