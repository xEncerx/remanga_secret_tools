import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'file_remote_datasource.g.dart';

/// Remote data source for file operations.
@RestApi()
// ignore: one_member_abstracts
abstract class FileRemoteDatasource {
  /// Creates a new instance of [FileRemoteDatasource].
  factory FileRemoteDatasource(Dio dio) = _FileRemoteDatasource;

  /// Downloads an image from the given [path].
  ///
  /// Returns the bytes of the image.
  @GET('{path}')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> downloadImage(@Path('path') String path);
}
