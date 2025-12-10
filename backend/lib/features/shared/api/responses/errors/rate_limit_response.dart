import 'package:backend/features/shared/shared.dart';

/// Extension for creating a rate limit error response.
extension RateLimitResponse on BaseErrorResponse {
  /// Creates a [BaseErrorResponse] for a rate limit error.
  static BaseErrorResponse create() => const BaseErrorResponse(
    statusCode: 429,
    errorCode: ErrorCode.rateLimitExceeded,
    detail: 'Too many requests',
  );
}
