import 'package:json_annotation/json_annotation.dart';

/// Defines error codes used across the API for consistent error handling.
@JsonEnum(valueField: 'errorCode', fieldRename: FieldRename.snake)
enum ErrorCode {
  /// 404 Not Found
  notFound('NOT_FOUND'),

  /// Validation error
  validationError('VALIDATION_ERROR'),

  /// 500 Internal Server Error
  internalError('INTERNAL_ERROR'),

  /// Rate limit exceeded
  rateLimitExceeded('RATE_LIMIT_EXCEEDED'),

  /// Service unavailable
  serviceUnavailable('SERVICE_UNAVAILABLE'),

  /// Method not allowed
  methodNotAllowed('METHOD_NOT_ALLOWED'),

  // Pack-specific
  /// Pack not found
  packNotFound('PACK_NOT_FOUND');

  const ErrorCode(this.errorCode);

  /// The string representation of the error code.
  final String errorCode;
}
