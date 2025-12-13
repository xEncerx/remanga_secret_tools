import 'package:flutter/widgets.dart';

/// Data model for a social link with label, URL, and icon.
class SocialLinkData {
  /// Creates a [SocialLinkData] instance.
  const SocialLinkData({
    required this.label,
    required this.url,
    required this.icon,
  });

  /// The label of the social link.
  final String label;

  /// The URL of the social link.
  final String url;

  /// The icon widget representing the social link.
  final Widget icon;
}
