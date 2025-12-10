import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

part 'pack_remote_api.g.dart';

/// Remote API for fetching pack data.
@RestApi(baseUrl: 'packs', callAdapter: EitherCallAdapter)
// ignore: one_member_abstracts
abstract class PackRemoteApi {
  /// Creates a new instance of [PackRemoteApi].
  factory PackRemoteApi(Dio dio) = _PackRemoteApi;

  /// Fetches a pack by its ID.
  @GET('/{id}')
  Future<Either<ApiException, PackDTO>> getPackById(@Path('id') int id);
}
