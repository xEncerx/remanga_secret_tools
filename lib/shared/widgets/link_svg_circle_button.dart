import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/link.dart';

/// A circular button that opens a link with an SVG icon.
class LinkSvgCircleButton extends StatelessWidget {
  /// Creates a [LinkSvgCircleButton] widget.
  const LinkSvgCircleButton({
    super.key,
    required this.url,
    required this.svgAssetPath,
    this.radius = 28,
    this.backgroundColor,
    this.tooltip,
  });

  /// The URL to open when the button is pressed.
  final String url;

  /// The radius of the circular button.
  final double radius;

  /// The path to the SVG asset to display as the button icon.
  final String svgAssetPath;

  /// The background color of the button.
  ///
  /// If null, the button will use the default color from the theme.
  final Color? backgroundColor;

  /// The tooltip text for the button.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final svgColor = backgroundColor ?? Theme.of(context).colorScheme.onSurface;

    return Link(
      uri: Uri.parse(url),
      target: LinkTarget.blank,
      builder: (context, followLink) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          child: IconButton(
            icon: SvgPicture.asset(
              svgAssetPath,
              color: svgColor,
              width: radius,
            ),
            onPressed: followLink,
            tooltip: tooltip,
          ),
        );
      },
    );
  }
}
