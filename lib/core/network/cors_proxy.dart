import '../core.dart';

/// A utility class for handling CORS proxying of URLs.
class CorsProxy {
  /// Returns a proxied URL using the specified CORS proxy.
  static String getProxiedUrl(String originalUrl, [String proxyUrl = EnvConfig.corsProxy]) {
    if (originalUrl.isEmpty || proxyUrl.isEmpty) return originalUrl;

    final encoded = Uri.encodeComponent(originalUrl);
    return '$proxyUrl?url=$encoded';
  }
}
