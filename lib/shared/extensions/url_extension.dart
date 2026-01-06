/// Extension methods for String to handle URL manipulations.
extension UrlExtension on String {
  static const Set<String> _videoExtensions = {'mp4', 'webm'};

  /// Ensures the URL is absolute by prepending the [baseUrl] if necessary.
  String toAbsoluteUrl(String baseUrl) {
    if (startsWith('http://') || startsWith('https://')) {
      return this;
    } else {
      return '$baseUrl$this';
    }
  }

  /// Determines if the URL points to a video file based on its extension.
  ///
  /// Returns `true` if the URL ends with a known video file extension.
  bool get isVideo {
    final extension = split('.').last.toLowerCase();
    return _videoExtensions.contains(extension);
  }
}
