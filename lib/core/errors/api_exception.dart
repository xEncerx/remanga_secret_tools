import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';
part 'api_exception.g.dart';

@freezed
/// Represents an API exception with detailed information.
abstract class ApiException with _$ApiException {
  /// Factory constructor for [ApiException].
  const factory ApiException({
    /// The HTTP status code of the error.
    required int statusCode,

    /// A specific error code representing the error type.
    required String errorCode,

    /// A detailed message describing the error.
    required String detail,
  }) = _ApiException;

  /// Creates an [ApiException] from a JSON map.
  factory ApiException.fromJson(Map<String, dynamic> json) => _$ApiExceptionFromJson(json);

  /// Creates an [ApiException] representing an internal server error.
  factory ApiException.internalServerError() => const ApiException(
    statusCode: 500,
    errorCode: 'INTERNAL_SERVER_ERROR',
    detail: 'Ошибка на стороне сервера...',
  );

  /// Creates an [ApiException] representing an unknown error.
  factory ApiException.unknownError() => const ApiException(
    statusCode: 520,
    errorCode: 'UNKNOWN_ERROR',
    detail: 'Произошла неизвестная ошибка :(',
  );
}
