import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A widget that displays an image from various sources with error handling and placeholders.
class CustomImage extends StatelessWidget {
  /// Creates a [CustomImage] widget.
  const CustomImage({
    super.key,
    required this.imagePath,
    required this.bypassCORS,
    bool isAsset = false,
    this.placeholder,
    this.errorWidget,
  }) : _isAsset = isAsset;

  /// Creates a [CustomImage] widget for network images.
  const CustomImage.network({
    super.key,
    required this.imagePath,
    this.bypassCORS = true,
    this.placeholder,
    this.errorWidget,
  }) : _isAsset = false;

  /// Creates a [CustomImage] widget for asset images.
  const CustomImage.asset({
    super.key,
    required this.imagePath,
    this.placeholder,
    this.errorWidget,
  }) : _isAsset = true,
       bypassCORS = false;

  /// The path of the image to display.
  final String imagePath;

  /// Whether to bypass CORS using a proxy.
  final bool bypassCORS;

  /// A widget to display while the image is loading.
  final Widget Function(BuildContext context, String url)? placeholder;

  /// A widget to display if an error occurs while loading the image.
  final Widget Function(BuildContext context, String url, Object error)? errorWidget;

  static const _errorWidget = Image(image: AssetImage('assets/images/error-cover.webp'));
  final bool _isAsset;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return errorWidget?.call(
            context,
            imagePath,
            'Error: Empty image path',
          ) ??
          _errorWidget;
    }

    return _isAsset
        ? Image.asset(imagePath)
        : CachedNetworkImage(
            // We use a CORS proxy to avoid CORS issues when loading images from certain domains.
            imageUrl: bypassCORS ? CorsProxy.getProxiedUrl(imagePath) : imagePath,
            errorWidget: errorWidget ?? (_, _, _) => _errorWidget,
            placeholder: placeholder,
          );
  }
}
