import 'package:backend/core/errors/errors.dart';
import 'package:backend/core/network/network.dart';
import 'package:backend/features/features.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/retrofit.dart';

part 'pack_remote_api.g.dart';

/// Remote API for fetching pack data.
@RestApi(baseUrl: 'shop/decks', callAdapter: EitherCallAdapter)
// ignore: one_member_abstracts
abstract class PackRemoteApi {
  /// Creates a new instance of [PackRemoteApi].
  factory PackRemoteApi(Dio dio) = _PackRemoteApi;

  /// Fetches a pack by its ID.
  @GET('/{id}')
  Future<Either<ApiException, PackEntity>> getPackById(@Path('id') int id);

  /// Fetches detailed information about a pack by its ID.
  @GET('/')
  Future<Either<ApiException, PaginationResponseEntity<PackDetailEntity>>>
  getPackDetailById(
    @Query('deck_id') int id,
  );
}
