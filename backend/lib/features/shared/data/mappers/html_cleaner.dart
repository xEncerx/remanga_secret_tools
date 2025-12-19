import 'package:html_unescape/html_unescape.dart';

/// A utility class for cleaning HTML content.
class HtmlCleaner {
  static final _unescape = HtmlUnescape();

  /// Cleans HTML content by removing tags and decoding entities.
  static String clean(String rawHtml) {
    final decoded = _unescape.convert(rawHtml);
    final cleaned = decoded.replaceAll(RegExp('<[^>]*>'), '');
    return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
