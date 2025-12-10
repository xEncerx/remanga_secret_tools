import 'package:backend/features/shared/shared.dart';
import 'package:dart_frog/dart_frog.dart';

/// Extension to convert [BaseErrorResponse] to a Dart Frog [Response].
extension ErrorToResponse on BaseErrorResponse {
  /// Converts the [BaseErrorResponse] to a Dart Frog [Response].
  Response toResponse() {
    return Response.json(
      statusCode: statusCode,
      body: toJson(),
    );
  }
}
