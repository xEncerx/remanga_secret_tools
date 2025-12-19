import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// API client for making HTTP requests.
class ApiClient {
  /// Constructor for ApiClient.
  ApiClient({
    required this.baseUrl,
    required this.logger,
    this.headers,
  });

  /// Logger instance for logging API client activities.
  final Talker logger;

  /// Base URL for the API.
  final String baseUrl;

  /// Default headers for the API requests.
  final Map<String, dynamic>? headers;

  /// Creates and configures a Dio HTTP client.
  Dio createClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers:
            headers ??
            {
              'Accept':
                  'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
              'Accept-Encoding': 'gzip, deflate, br, zstd',
              'Accept-Language': 'ru,en;q=0.9,en-GB;q=0.8,en-US;q=0.7',
              'Cache-Control': 'no-cache',
              'Pragma': 'no-cache',
              'Priority': 'u=0, i',
              'Sec-Ch-Ua-Mobile': '?0',
              'Sec-Ch-Ua-Platform': '"Windows"',
              'Sec-Fetch-Dest': 'document',
              'Sec-Fetch-Mode': 'navigate',
              'Sec-Fetch-Site': 'none',
              'Sec-Fetch-User': '?1',
              'Upgrade-Insecure-Requests': '1',
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0',
            },
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
