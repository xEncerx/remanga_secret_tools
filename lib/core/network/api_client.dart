import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// API client for making HTTP requests.
class ApiClient {
  /// Constructor for ApiClient.
  ApiClient({
    required this.baseUrl,
    required this.logger,
  });

  /// Logger instance for logging API client activities.
  final Talker logger;

  /// Base URL for the API.
  final String baseUrl;

  /// Creates and configures a Dio HTTP client.
  Dio createClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.addAll(<Interceptor>[
      TalkerDioLogger(
        talker: logger,
        settings: const TalkerDioLoggerSettings(
          printResponseData: false,
        ),
      ),
    ]);

    return dio;
  }
}
