import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';
part 'api_exception.g.dart';

/// Represents detailed information about an API exception.
@freezed
abstract class ApiExceptionDetail with _$ApiExceptionDetail {
  /// Factory constructor for [ApiExceptionDetail].
  const factory ApiExceptionDetail({
    /// The error message associated with the API exception.
    required String message,

    /// The error code associated with the API exception.
    required int code,
  }) = _ApiExceptionDetail;

  /// Creates a [ApiExceptionDetail] from a JSON map.
  factory ApiExceptionDetail.fromJson(Map<String, dynamic> json) =>
      _$ApiExceptionDetailFromJson(json);
}

@freezed
/// Represents an API exception with detailed information.
abstract class ApiException with _$ApiException {
  /// Factory constructor for [ApiException].
  const factory ApiException({
    /// Detailed information about the API exception.
    required ApiExceptionDetail detail,
  }) = _ApiException;

  /// Creates an [ApiException] from a JSON map.
  factory ApiException.fromJson(Map<String, dynamic> json) =>
      _$ApiExceptionFromJson(json);

  /// Creates an [ApiException] representing an internal server error.
  factory ApiException.internalServerError() => const ApiException(
    detail: ApiExceptionDetail(
      message: 'Internal Server Error',
      code: 500,
    ),
  );
}
