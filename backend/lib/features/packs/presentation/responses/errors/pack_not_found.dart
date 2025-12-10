import 'package:backend/features/features.dart';

/// Extension to create a Pack Not Found error response.
extension PackNotFoundResponse on BaseErrorResponse {
  /// Creates a [BaseErrorResponse] for a pack not found error.
  static BaseErrorResponse create(String packId) => BaseErrorResponse(
    statusCode: 404,
    errorCode: ErrorCode.packNotFound,
    detail: 'Pack with id $packId not found',
  );
}
