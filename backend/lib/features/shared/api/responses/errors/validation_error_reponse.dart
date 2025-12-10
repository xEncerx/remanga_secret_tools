import 'package:backend/features/shared/shared.dart';

/// Extension to create a Validation Error response.
extension ValidationErrorResponse on BaseErrorResponse {
  /// Creates a [BaseErrorResponse] for a validation error.
  static BaseErrorResponse create(String validationMessage) =>
      BaseErrorResponse(
        statusCode: 400,
        errorCode: ErrorCode.validationError,
        detail: validationMessage,
      );
}
