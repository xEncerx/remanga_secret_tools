import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:talker/talker.dart';

Future<Response> onRequest(
  RequestContext context,
  String packId,
) async {
  final parsedPackId = int.tryParse(packId);
  if (parsedPackId == null) {
    return ValidationErrorResponse.create(
      'Invalid packId parameter',
    ).toResponse();
  }

  try {
    final pack = await getIt<PacksUseCases>().getPackById(parsedPackId);

    if (pack == null) {
      return PackNotFoundResponse.create(packId).toResponse();
    }

    return Response.json(body: pack.toJson());
  } catch (e, stackTrace) {
    getIt<Talker>().error('Error getting pack $packId', e, stackTrace);

    return const BaseErrorResponse(
      statusCode: 500,
      errorCode: ErrorCode.internalError,
      detail: 'Failed to retrieve pack',
    ).toResponse();
  }
}
