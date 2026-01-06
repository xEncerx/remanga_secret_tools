import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Model representing proxy configuration.
class ProxyConfig {
  /// Creates a [ProxyConfig] instance.
  ProxyConfig({
    required this.ip,
    required this.port,
    this.username,
    this.password,
  });

  /// The IP address of the proxy server.
  final String ip;

  /// The port of the proxy server.
  final int port;

  /// The username for proxy authentication.
  final String? username;

  /// The password for proxy authentication.
  final String? password;

  /// Indicates whether authentication credentials are provided.
  bool get hasAuth => username != null && password != null;

  /// Creates a [ProxyConfig] from a string representation.
  static ProxyConfig? fromString(String proxyString) {
    if (proxyString.isEmpty) return null;

    String? username;
    String? password;
    String hostPort;

    try {
      if (proxyString.contains('@')) {
        final parts = proxyString.split('@');
        if (parts.length != 2) return null;

        final authParts = parts[0].split(':');
        if (authParts.length != 2) return null;

        username = authParts[0];
        password = authParts[1];
        hostPort = parts[1];
      } else {
        hostPort = proxyString;
      }

      final hostPortParts = hostPort.split(':');
      if (hostPortParts.length != 2) return null;

      final ip = hostPortParts[0];
      final port = int.tryParse(hostPortParts[1]);

      if (port == null) return null;

      return ProxyConfig(
        ip: ip,
        port: port,
        username: username,
        password: password,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Extension to configure proxy settings for Dio HTTP client.
extension DioProxyExtension on Dio {
  /// Sets up the Dio HTTP client to use the specified proxy configuration.
  void setupProxy(ProxyConfig proxy) {
    httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient()
          ..findProxy = (uri) {
            return 'PROXY ${proxy.ip}:${proxy.port}';
          };

        if (proxy.hasAuth) {
          client.addProxyCredentials(
            proxy.ip,
            proxy.port,
            'realm',
            HttpClientBasicCredentials(proxy.username!, proxy.password!),
          );
        }

        return client;
      },
    );
  }
}
