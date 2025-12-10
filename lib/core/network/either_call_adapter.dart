import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/retrofit.dart';

import '../core.dart';

/// A custom call adapter that converts API calls into an Either type
class EitherCallAdapter<T> extends CallAdapter<Future<T>, Future<Either<ApiException, T>>> {
  @override
  Future<Either<ApiException, T>> adapt(Future<T> Function() call) async {
    try {
      final response = await call();
      return Right(response);
    } on DioException catch (dioError) {
      final statusCode = dioError.response?.statusCode ?? 500;

      if (statusCode == 500) {
        return Left(ApiException.internalServerError());
      }

      final errorData = dioError.response?.data;
      if (errorData is Map<String, dynamic>) {
        try {
          final apiException = ApiException.fromJson(errorData);
          return Left(apiException);
        } catch (_) {
          return Left(ApiException.unknownError());
        }
      } else {
        return Left(ApiException.internalServerError());
      }
    }
  }
}
