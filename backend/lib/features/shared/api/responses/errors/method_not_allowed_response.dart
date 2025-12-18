import 'package:backend/features/shared/shared.dart';

/// Extension for creating a rate limit error response.
extension MethodNotAllowedResponse on BaseErrorResponse {
  /// Creates a [BaseErrorResponse] for a method not allowed error.
  static BaseErrorResponse create() => const BaseErrorResponse(
    statusCode: 405,
    errorCode: ErrorCode.methodNotAllowed,
    detail: 'Method not allowed',
  );
}
