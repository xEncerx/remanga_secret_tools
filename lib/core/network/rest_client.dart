import 'package:dio/dio.dart';

import '../../features/features.dart';

/// A REST client for accessing various remote APIs.
class RestClient {
  /// Creates a new instance of [RestClient] with the given [dio] instance.
  RestClient(this.dio);

  /// The Dio instance used for making HTTP requests.
  final Dio dio;

  PackRemoteApi? _packRemoteApi;

  /// Provides access to the [PackRemoteApi].
  PackRemoteApi get packs => _packRemoteApi ??= PackRemoteApi(dio);
}
